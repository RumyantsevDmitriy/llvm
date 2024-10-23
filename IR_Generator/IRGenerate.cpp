#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Support/FileSystem.h>
#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/IR/Attributes.h"

#include "sim.h"

using namespace llvm;

int main()
{
    LLVMContext context;
    Module *module= new Module("app.c", context);
    IRBuilder<> builder(context);

    Type *i32Type = Type::getInt32Ty(context);
    Type *i64Type = Type::getInt64Ty(context);
    Type *voidType = Type::getVoidTy(context);
    Type* int32Ty = builder.getInt32Ty();
    Type* int64Ty = builder.getInt64Ty();
    Type* ptrTy = PointerType::get(int32Ty, 0);
    Type *arrayType = ArrayType::get(i32Type, 4800);
    PointerType *ptrType = arrayType->getPointerTo();

    // countNeighbors
    FunctionType* countNeighborsType = FunctionType::get(i32Type, {ptrType, i32Type, i32Type, i32Type, i32Type}, false);
    Function* countNeighborsFunc = Function::Create(countNeighborsType, Function::ExternalLinkage, "countNeighbors", module);

    BasicBlock *entryBlock1 = BasicBlock::Create(context, "entry", countNeighborsFunc);
    BasicBlock *loopBlock = BasicBlock::Create(context, "loop", countNeighborsFunc);
    BasicBlock *afterLoopBlock = BasicBlock::Create(context, "after_loop", countNeighborsFunc);
    builder.SetInsertPoint(entryBlock1);

    auto args3 = countNeighborsFunc->arg_begin();
    Value *gridPtr = args3++;
    Value *row = args3++;
    Value *col = args3++;
    Value *numRows = args3++;
    Value *numCols = args3++;

    // Начальная инициализация счетчика соседей
    PHINode *neighborCount = builder.CreatePHI(i32Type, 2, "neighborCount");
    neighborCount->addIncoming(ConstantInt::get(i32Type, 0), entryBlock1);

    // Основной цикл по соседям
    for (int i = -1; i <= 1; ++i) {
        for (int j = -1; j <= 1; ++j) {
            if (i == 0 && j == 0) continue; // Пропустить саму ячейку

            // Загружаем текущее значение для i
            Value *currentI = builder.CreateAlloca(i32Type, nullptr, "currentI");
            builder.CreateStore(ConstantInt::get(i32Type, i), currentI);
            currentI = builder.CreateLoad(i32Type, currentI, "loadedCurrentI");

            // Определение соседней ячейки
            Value *neighborRow = builder.CreateAdd(row, currentI, "neighborRow");
            Value *neighborCol = builder.CreateAdd(col, ConstantInt::get(i32Type, j), "neighborCol");

            Value *isRowValid = builder.CreateICmpSGT(neighborRow, ConstantInt::get(i32Type, -1), "isRowValid");
            Value *isColValid = builder.CreateICmpSLT(neighborCol, numCols, "isColValid");
            Value *isValidNeighbor = builder.CreateAnd(isRowValid, isColValid, "isValidNeighbor");

            BasicBlock *neighborValidBlock = BasicBlock::Create(context, "neighbor_valid", countNeighborsFunc);
            BasicBlock *neighborInvalidBlock = BasicBlock::Create(context, "neighbor_invalid", countNeighborsFunc);

            builder.CreateCondBr(isValidNeighbor, neighborValidBlock, neighborInvalidBlock);

            // Ветка для валидного соседа
            builder.SetInsertPoint(neighborValidBlock);
            Value *neighborIndex = builder.CreateMul(builder.CreateSExt(neighborRow, i64Type), builder.CreateSExt(numCols, i64Type), "neighborIndex");
            neighborIndex = builder.CreateAdd(neighborIndex, builder.CreateSExt(neighborCol, i64Type), "finalNeighborIndex");
            Value *neighborPtr = builder.CreateGEP(i32Type, gridPtr, neighborIndex, "neighborPtr");
            Value *neighborValue = builder.CreateLoad(i32Type, neighborPtr, "neighborValue");

            // Обновление текущего значения
            Value *updatedCount = builder.CreateAdd(neighborCount, neighborValue, "updatedCount");
            neighborCount->addIncoming(updatedCount, neighborValidBlock);

            // Переход в блок для невалидного соседа
            builder.CreateBr(neighborInvalidBlock);

            // Ветка для невалидного соседа
            builder.SetInsertPoint(neighborInvalidBlock);
        }
    }

    // Переход в блок после обработки соседей
    BasicBlock *returnBlock = BasicBlock::Create(context, "return", countNeighborsFunc);
    builder.CreateBr(returnBlock);

    // После цикла
    builder.SetInsertPoint(returnBlock);
    builder.CreateRet(neighborCount);  // финальное значение после обработки всех соседей


    // app
    FunctionType *appType = FunctionType::get(voidType, false);
    Function *appFunc = Function::Create(appType, Function::ExternalLinkage, "app", module);

    // Создание базовых блоков
    BasicBlock *entryBlock = BasicBlock::Create(context, "entry", appFunc);
    BasicBlock *block3 = BasicBlock::Create(context, "block3", appFunc);
    BasicBlock *block6 = BasicBlock::Create(context, "block6", appFunc);
    BasicBlock *block9 = BasicBlock::Create(context, "block9", appFunc);
    BasicBlock *block17 = BasicBlock::Create(context, "block17", appFunc);
    BasicBlock *block20 = BasicBlock::Create(context, "block20", appFunc);
    BasicBlock *block23 = BasicBlock::Create(context, "block23", appFunc);
    BasicBlock *block25 = BasicBlock::Create(context, "block25", appFunc);
    BasicBlock *block42 = BasicBlock::Create(context, "block42", appFunc);
    BasicBlock *block44 = BasicBlock::Create(context, "block44", appFunc);
    BasicBlock *block47 = BasicBlock::Create(context, "block47", appFunc);
    BasicBlock *block74 = BasicBlock::Create(context, "block74", appFunc);

    // Начальный блок
    builder.SetInsertPoint(entryBlock);

    // Создание временных массивов
    AllocaInst *array1 = builder.CreateAlloca(arrayType, nullptr, "array1");
    AllocaInst *array2 = builder.CreateAlloca(arrayType, nullptr, "array2");

    // Начало времени жизни для массивов
    Function *lifetimeStartFunc = module->getFunction("llvm.lifetime.start.p0");
    if (!lifetimeStartFunc) {
        FunctionType *lifetimeStartType = FunctionType::get(i32Type, {}, false);
        lifetimeStartFunc = Function::Create(lifetimeStartType, Function::ExternalLinkage, "llvm.lifetime.start.p0", module);
    }
    builder.CreateCall(lifetimeStartFunc, {ConstantInt::get(i64Type, 19200), builder.CreateBitCast(array1, PointerType::getInt8Ty(context))});
    builder.CreateCall(lifetimeStartFunc, {ConstantInt::get(i64Type, 19200), builder.CreateBitCast(array2, PointerType::getInt8Ty(context))});

    // Переход в блок 3
    builder.CreateBr(block3);

    // Блок 3
    builder.SetInsertPoint(block3);
    PHINode *phi1 = builder.CreatePHI(i64Type, 2, "phi1");
    phi1->addIncoming(ConstantInt::get(i64Type, 0), entryBlock);
    Value *ptrElem = builder.CreateGEP(i32Type, array1, phi1, "ptrElem");
    builder.CreateBr(block9);

    // Блок 9
    builder.SetInsertPoint(block9);
    PHINode *phi2 = builder.CreatePHI(i64Type, 2, "phi2");
    phi2->addIncoming(ConstantInt::get(i64Type, 0), block3);

    // Вызов simRand и расчеты
    Function *simRandFunc = module->getFunction("simRand");
    if (!simRandFunc) {
        FunctionType *simRandType = FunctionType::get(i32Type, {}, false);
        simRandFunc = Function::Create(simRandType, Function::ExternalLinkage, "simRand", module);
    }
    Value *randVal = builder.CreateCall(simRandFunc, {}, "randVal");
    Value *modVal = builder.CreateSRem(randVal, ConstantInt::get(i32Type, 2), "modVal");
    Value *mulVal = builder.CreateMul(phi2, ConstantInt::get(i64Type, 80), "mulVal");
    Value *ptrStore = builder.CreateGEP(i32Type, ptrElem, mulVal, "ptrStore");
    builder.CreateStore(modVal, ptrStore);

    // Увеличение индекса и проверка
    Value *phi2Next = builder.CreateAdd(phi2, ConstantInt::get(i64Type, 1), "phi2Next");
    Value *cond1 = builder.CreateICmpEQ(phi2Next, ConstantInt::get(i64Type, 60), "cond1");
    builder.CreateCondBr(cond1, block6, block9);
    phi2->addIncoming(phi2Next, block9);

    // Блок 6
    builder.SetInsertPoint(block6);
    Value *phi1Next = builder.CreateAdd(phi1, ConstantInt::get(i64Type, 1), "phi1Next");
    Value *cond2 = builder.CreateICmpEQ(phi1Next, ConstantInt::get(i64Type, 80), "cond2");
    builder.CreateCondBr(cond2, block17, block3);
    phi1->addIncoming(phi1Next, block6);

    // Блок 17
    builder.SetInsertPoint(block17);
    PHINode *phi3 = builder.CreatePHI(i64Type, 2, "phi3");
    phi3->addIncoming(ConstantInt::get(i64Type, 0), block6);
    Value *truncPhi3 = builder.CreateTrunc(phi3, i32Type, "truncPhi3");
    builder.CreateBr(block25);

    // Блок 25
    builder.SetInsertPoint(block25);
    PHINode *phi4 = builder.CreatePHI(i64Type, 2, "phi4");
    phi4->addIncoming(ConstantInt::get(i64Type, 0), block17);

    Value *neighborCount1 = builder.CreateCall(countNeighborsFunc, {array1, truncPhi3, builder.CreateTrunc(phi4, i32Type), ConstantInt::get(i32Type, 80), ConstantInt::get(i32Type, 60)}, "neighborCount");

    // Остальные инструкции: загрузка значений, вычисления, сохранение
    Value *mulVal2 = builder.CreateMul(phi4, ConstantInt::get(i64Type, 80), "mulVal2");
    Value *addVal = builder.CreateAdd(mulVal2, phi3, "addVal");
    Value *ptrLoad = builder.CreateGEP(i32Type, array1, addVal, "ptrLoad");
    Value *loadVal = builder.CreateLoad(i32Type, ptrLoad, "loadVal");
    Value *condAlive = builder.CreateICmpEQ(loadVal, ConstantInt::get(i32Type, 1), "condAlive");
    
    Value *condDeath = builder.CreateICmpEQ(builder.CreateAnd(neighborCount1, ConstantInt::get(i32Type, -2)), ConstantInt::get(i32Type, 2), "condDeath");
    Value *condBirth = builder.CreateICmpEQ(neighborCount1, ConstantInt::get(i32Type, 3), "condBirth");
    
    Value *result = builder.CreateSelect(condAlive, condDeath, condBirth, "result");
    Value *resultZext = builder.CreateZExt(result, i32Type, "resultZext");

    // Сохранение результата в array2
    Value *ptrStore2 = builder.CreateGEP(i32Type, array2, addVal, "ptrStore2");
    builder.CreateStore(resultZext, ptrStore2);

    // Увеличение индекса и проверка
    Value *phi4Next = builder.CreateAdd(phi4, ConstantInt::get(i64Type, 1), "phi4Next");
    Value *cond3 = builder.CreateICmpEQ(phi4Next, ConstantInt::get(i64Type, 60), "cond3");
    builder.CreateCondBr(cond3, block20, block25);
    phi4->addIncoming(phi4Next, block25);

    // Блок 20
    builder.SetInsertPoint(block20);
    Value *phi3Next = builder.CreateAdd(phi3, ConstantInt::get(i64Type, 1), "phi3Next");
    Value *cond4 = builder.CreateICmpEQ(phi3Next, ConstantInt::get(i64Type, 80), "cond4");
    builder.CreateCondBr(cond4, block42, block17);
    phi3->addIncoming(phi3Next, block20);

    // Блок 42
    builder.SetInsertPoint(block42);

    // Вызов gridDraw
    Function *gridDrawFunc = module->getFunction("gridDraw");
    if (!gridDrawFunc) {
        FunctionType *gridDrawType = FunctionType::get(voidType, {ptrType, i32Type, i32Type}, false);
        gridDrawFunc = Function::Create(gridDrawType, Function::ExternalLinkage, "gridDraw", module);
    }
    builder.CreateCall(gridDrawFunc, {array2, ConstantInt::get(i32Type, 80), ConstantInt::get(i32Type, 60)});

    // Вызов simFlush
    Function *simFlushFunc = module->getFunction("simFlush");
    if (!simFlushFunc) {
        FunctionType *simFlushType = FunctionType::get(voidType, {}, false);
        simFlushFunc = Function::Create(simFlushType, Function::ExternalLinkage, "simFlush", module);
    }
    builder.CreateCall(simFlushFunc, {});

    // Переход в блок 23
    builder.CreateBr(block23);

    // Блок 23 (начало нового цикла или завершение)
    builder.SetInsertPoint(block23);
    builder.CreateBr(block3);  // Перезапуск основного цикла.

    // simPutPixel
    FunctionType *simPutPixelType = FunctionType::get(Type::getVoidTy(context), 
                                                      {Type::getInt32Ty(context), 
                                                       Type::getInt32Ty(context), 
                                                       Type::getInt32Ty(context)}, 
                                                      false);
    
    Function *simPutPixelFunc = Function::Create(simPutPixelType, 
                                                 Function::ExternalLinkage, 
                                                 "simPutPixel", 
                                                 module);
    
    // Добавляем атрибуты функции
    simPutPixelFunc->addFnAttr(Attribute::NoUndef);
    simPutPixelFunc->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);

    // Дампим LLVM IR
    module->print(outs(), nullptr);

    // LLVM IR Interpreter
    outs() << "[EE] Run\n";
    InitializeNativeTarget();
    InitializeNativeTargetAsmPrinter();

    ExecutionEngine *ee = EngineBuilder(std::unique_ptr<Module>(module)).create();

    ee->InstallLazyFunctionCreator([&](const std::string &fnName) -> void * {
        if (fnName == "simPutPixel") {
            return reinterpret_cast<void *>(simPutPixel);
        }
        if (fnName == "simFlush") {
            return reinterpret_cast<void *>(simFlush);
        }
        if (fnName == "simRand") {
            return reinterpret_cast<void *>(simRand);
        }
        return nullptr;
    });
    ee->finalizeObject();

    simInit();

    ArrayRef<GenericValue> noargs;
    GenericValue v = ee->runFunction(appFunc, noargs);
    outs() << "[EE] Result: " << v.IntVal << "\n";

    simExit();
    return EXIT_SUCCESS;

}