#define DEBUG_TYPE "max_stack_height"
#include "max_stack_height.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Debug.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Constants.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/IR/CFG.h"

using namespace llvm;

char max_stack_height::ID = 0;
static RegisterPass<max_stack_height>
X("ssh", "To Determine the max static stack height (ssh) of a function");

bool 
max_stack_height::runOnFunction(Function &F) {
  Func = &F;
  
  perform_dfa();

  return false; // Analysis pass
}

/*******************************************************************
  * Function :   perform_dfa
  * Purpose  :   Entry point for DFA
********************************************************************/
void
max_stack_height::perform_dfa() {
  initialize_dfa_framework();
  
  perform_const_dfa();
  
  perform_global_dfa();

  print_flow_equations();

}

/*******************************************************************
  * Function :   initialize_dfa_framework
  * Purpose  :   Allocates the data flow values
********************************************************************/
void
max_stack_height::initialize_dfa_framework() {
  for (Function::iterator BB = Func->begin(), E = Func->end(); BB != E; ++BB) {
    dfva* dfvaInstance = new dfva(3,0);
    BBMap[BB] = dfvaInstance;
  }
}

/*******************************************************************
 * Function :   perform_const_dfa
 * Purpose  :   Calculate the local sets GEN
********************************************************************/
void
max_stack_height::perform_const_dfa() {

  dfva* dfvaInstance;
  for (Function::iterator BB = Func->begin(), E = Func->end(); BB != E; ++BB) {
    dfvaInstance = BBMap[BB];
    (*dfvaInstance)[GEN] = calculate_max_height_BB(BB);
  }
}

height_ty 
max_stack_height::calculate_max_height_BB(BasicBlock *BB) {

  height_ty  max_height = 0;
  for (BasicBlock::iterator I = BB->begin(), E = BB->end(); I != E; ++I) {
    if(LoadInst* ld_inst = dyn_cast<LoadInst>(&*I)) {

      const Value* ptr_op = ld_inst->getPointerOperand();
      StringRef ptr_op_name = ptr_op->getName();

      if(0 ==  ptr_op_name.compare("RBP_val") || 
          0 ==  ptr_op_name.compare("RSP_val")) {

        DEBUG(errs()<< *ld_inst << "\n");

        for (Value::user_iterator i = ld_inst->user_begin(), e = ld_inst->user_end(); 
            i != e; ++i) {
          if (Instruction *user_inst = dyn_cast<Instruction>(*i)) {
            unsigned opcode = user_inst->getOpcode();
            if(Instruction::Add == opcode || Instruction::Sub == opcode) {
                assert(user_inst->isBinaryOp());

                DEBUG(errs()<< " "  << *user_inst << " : " );

                Value* op1 = user_inst->getOperand(0);
                Value* op2 = user_inst->getOperand(1);
                height_ty offset = 0;
                height_ty abs_offset = 0;
                ConstantInt *cosnt_val = NULL;


                assert(((NULL != dyn_cast<ConstantInt>(op1)) || 
                    (NULL != dyn_cast<ConstantInt>(op2))) && 
                    "One of operands should be constants");

                cosnt_val = dyn_cast<ConstantInt>(op1);
                if(NULL == cosnt_val) {
                  cosnt_val = dyn_cast<ConstantInt>(op2);
                }

                assert(NULL != cosnt_val && "offset is an variable expression");

                offset = cosnt_val->getLimitedValue();

                if(Instruction::Add == opcode && offset < 0) {
                  abs_offset = -1*offset;
                } else if(Instruction::Sub == opcode && offset > 0) {
                  abs_offset = offset;
                }
                max_height = max_height < abs_offset ? abs_offset : max_height;

                DEBUG(errs()<< abs_offset << "\n");
            }
          }
        } 

      }
    } 
  } 

  return max_height;
}

/*******************************************************************
 * Function :   perform_global_dfa
 * Purpose  :   perform the global data flow analysis
********************************************************************/
void
max_stack_height::perform_global_dfa() {

  bool Changed = false;
  height_ty top = 0 ;
  // bitVector for in[B] of start node
  height_ty initVector = 0;

  // initialize OUT set of each basic block to top
  for (Function::iterator BB = Func->begin(), E = Func->end(); BB != E; ++BB) {
    dfva* dfvaInstance = BBMap[BB];
    (*dfvaInstance)[OUT] = top ;
  }

  do {
    Changed = false;
    ReversePostOrderTraversal<Function*> RPOT(Func);

    for (ReversePostOrderTraversal<Function*>::rpo_iterator I = RPOT.begin(), 
        E = RPOT.end(); I != E; ++I) {
      BasicBlock* BB = *I;
      dfva* dfvaInstance = BBMap[BB];

      // this vector would be initialized accordingly later by the 
      // first predecessor while taking a meet over predecessors
      height_ty meetOverPreds = 0;

      // go over predecessors and take a meet
      bool first = true;
      for(pred_iterator PI = pred_begin(BB), PE = pred_end(BB); PI!=PE; ++PI) {
          
        height_ty meetExpression =  (*(BBMap[*PI]))[OUT];

        if(first) {
          first = false;
          meetOverPreds = meetExpression;
        } else {
          if(meetOverPreds != meetExpression) {
            meetOverPreds  = -1;
          } 
        }
      }
   
      // no predecessor, this is the start block s.
      if(first) {
        meetOverPreds = initVector;
      }

      // 'In' as a function of pred 'Out's
      (*dfvaInstance)[IN] = meetOverPreds;   
      height_ty old_out = (*dfvaInstance)[OUT];

      // 'Out' as a function of 'In'
      (*dfvaInstance)[OUT] = ((*dfvaInstance)[IN] == -1) ? -1 : (*dfvaInstance)[IN] + (*dfvaInstance)[GEN];
  
      height_ty new_out = (*dfvaInstance)[OUT];
      if(old_out != new_out) {
        Changed = true;
      }
    }
  } while(Changed);
}

/*******************************************************************
 * Function :   print_flow_equations
 * Purpose  :   print the data flow values for each BB
********************************************************************/
void
max_stack_height::print_flow_equations() {

  dfva* dfvaInstance;
  StringRef Fname = Func->getName();
  for (Function::iterator BB = Func->begin(), E = Func->end(); BB != E; ++BB) {
    dfvaInstance = BBMap[BB];
    StringRef BBname = (*BB).getName();
    errs() << Fname << "::" << BBname << "\n";
    for(uint32_t i = 0; i < TOTAL_DFA_VALUES; i++){
  
      switch(i) {
        case(IN)  : (errs() << "    IN "); break;
        case(GEN) : (errs() << "  GEN "); break;
        case(OUT) : (errs() << "  OUT "); break;
      }
      
      (errs() << (*dfvaInstance)[i]); 
    }
    (errs() << "\n------------\n"); 
  }
}
