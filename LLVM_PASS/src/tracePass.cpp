#include "llvm/IR/IRBuilder.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

using namespace llvm;

struct TracePass: public PassInfoMixin<TracePass> 
{
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &FAM)
    {
        StringRef LOGGER_NAME = "instrTrace";

        LLVMContext &Ctx = M.getContext();
        IRBuilder<> builder(Ctx);

        Type *retType = Type::getVoidTy(Ctx);
        ArrayRef<Type *> funcStartParamTypes = { builder.getInt8Ty()->getPointerTo(),
                                                 builder.getInt8Ty()->getPointerTo(),
                                                 builder.getInt8Ty()->getPointerTo() };
        FunctionType *LoggerType = FunctionType::get(retType, funcStartParamTypes, false);
        FunctionCallee logFunc = M.getOrInsertFunction(LOGGER_NAME, LoggerType);

        for (auto &&F : M) {
            if (F.getName() == LOGGER_NAME)
            {
                continue;
            }
            for (auto &&B : F)
            {
                for (auto &&I : B)
                {
                    if (dyn_cast<PHINode>(&I) != nullptr)
                    {
                        continue;
                    }
                    builder.SetInsertPoint(&I);
                    Value* opcodeName = builder.CreateGlobalStringPtr(I.getOpcodeName());

                    for (auto&& use: I.uses())
                    {
                        Instruction* useInstr = dyn_cast<Instruction>(use);
                        if (useInstr == nullptr)
                        {
                            continue;
                        }
                        builder.SetInsertPoint(useInstr);
                        Value* useOpcodeName = builder.CreateGlobalStringPtr(useInstr->getOpcodeName());
                        Value *args[] = {opcodeName, useOpcodeName};
                        builder.CreateCall(logFunc, args);
                    }
                }
            }
        }

    return PreservedAnalyses::none();
    }
};

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo()
{
  auto callback = [](PassBuilder &PB)
  {
    PB.registerOptimizerLastEPCallback(
        [](ModulePassManager &MPM, [[maybe_unused]] OptimizationLevel)
        {
          MPM.addPass(TracePass{});
          return true;
        });
  };

  return {LLVM_PLUGIN_API_VERSION, "Instruction Trace Pass", "0.0.1", callback};
}