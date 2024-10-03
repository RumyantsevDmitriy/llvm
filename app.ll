; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @gridInit(ptr nocapture noundef writeonly %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp sgt i32 %1, 0
  br i1 %4, label %5, label %14

5:                                                ; preds = %3
  %6 = icmp sgt i32 %2, 0
  %7 = zext nneg i32 %1 to i64
  %8 = zext nneg i32 %1 to i64
  %9 = zext nneg i32 %2 to i64
  br label %10

10:                                               ; preds = %5, %15
  %11 = phi i64 [ 0, %5 ], [ %16, %15 ]
  br i1 %6, label %12, label %15

12:                                               ; preds = %10
  %13 = getelementptr i32, ptr %0, i64 %11
  br label %18

14:                                               ; preds = %15, %3
  ret void

15:                                               ; preds = %18, %10
  %16 = add nuw nsw i64 %11, 1
  %17 = icmp eq i64 %16, %8
  br i1 %17, label %14, label %10, !llvm.loop !5

18:                                               ; preds = %12, %18
  %19 = phi i64 [ 0, %12 ], [ %24, %18 ]
  %20 = tail call i32 (...) @simRand() #6
  %21 = srem i32 %20, 2
  %22 = mul nsw i64 %19, %7
  %23 = getelementptr i32, ptr %13, i64 %22
  store i32 %21, ptr %23, align 4, !tbaa !7
  %24 = add nuw nsw i64 %19, 1
  %25 = icmp eq i64 %24, %9
  br i1 %25, label %15, label %18, !llvm.loop !11
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

declare i32 @simRand(...) local_unnamed_addr #2

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @gridUpdate(ptr nocapture noundef %0, ptr nocapture noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #3 {
  %5 = icmp sgt i32 %2, 0
  br i1 %5, label %6, label %47

6:                                                ; preds = %4
  %7 = icmp sgt i32 %3, 0
  %8 = zext nneg i32 %2 to i64
  %9 = zext nneg i32 %2 to i64
  %10 = zext i32 %3 to i64
  br label %11

11:                                               ; preds = %6, %24
  %12 = phi i64 [ 0, %6 ], [ %25, %24 ]
  br i1 %7, label %13, label %24

13:                                               ; preds = %11
  %14 = trunc i64 %12 to i32
  br label %27

15:                                               ; preds = %24
  br i1 %5, label %16, label %47

16:                                               ; preds = %15
  %17 = icmp sgt i32 %3, 0
  %18 = zext nneg i32 %2 to i64
  %19 = zext nneg i32 %2 to i64
  %20 = and i64 %10, 3
  %21 = icmp ult i32 %3, 4
  %22 = and i64 %10, 2147483644
  %23 = icmp eq i64 %20, 0
  br label %44

24:                                               ; preds = %27, %11
  %25 = add nuw nsw i64 %12, 1
  %26 = icmp eq i64 %25, %9
  br i1 %26, label %15, label %11, !llvm.loop !12

27:                                               ; preds = %13, %27
  %28 = phi i64 [ 0, %13 ], [ %42, %27 ]
  %29 = trunc i64 %28 to i32
  %30 = tail call i32 @countNeighbors(ptr noundef %0, i32 noundef %14, i32 noundef %29, i32 noundef %2, i32 noundef %3)
  %31 = mul nsw i64 %28, %8
  %32 = add nuw nsw i64 %31, %12
  %33 = getelementptr inbounds i32, ptr %0, i64 %32
  %34 = load i32, ptr %33, align 4, !tbaa !7
  %35 = icmp eq i32 %34, 1
  %36 = and i32 %30, -2
  %37 = icmp eq i32 %36, 2
  %38 = icmp eq i32 %30, 3
  %39 = select i1 %35, i1 %37, i1 %38
  %40 = zext i1 %39 to i32
  %41 = getelementptr inbounds i32, ptr %1, i64 %32
  store i32 %40, ptr %41, align 4
  %42 = add nuw nsw i64 %28, 1
  %43 = icmp eq i64 %42, %10
  br i1 %43, label %24, label %27, !llvm.loop !13

44:                                               ; preds = %16, %61
  %45 = phi i64 [ 0, %16 ], [ %62, %61 ]
  br i1 %17, label %46, label %61

46:                                               ; preds = %44
  br i1 %21, label %48, label %64

47:                                               ; preds = %61, %4, %15
  ret void

48:                                               ; preds = %64, %46
  %49 = phi i64 [ 0, %46 ], [ %90, %64 ]
  br i1 %23, label %61, label %50

50:                                               ; preds = %48, %50
  %51 = phi i64 [ %58, %50 ], [ %49, %48 ]
  %52 = phi i64 [ %59, %50 ], [ 0, %48 ]
  %53 = mul nsw i64 %51, %18
  %54 = add nuw nsw i64 %53, %45
  %55 = getelementptr inbounds i32, ptr %1, i64 %54
  %56 = load i32, ptr %55, align 4, !tbaa !7
  %57 = getelementptr inbounds i32, ptr %0, i64 %54
  store i32 %56, ptr %57, align 4, !tbaa !7
  %58 = add nuw nsw i64 %51, 1
  %59 = add i64 %52, 1
  %60 = icmp eq i64 %59, %20
  br i1 %60, label %61, label %50, !llvm.loop !14

61:                                               ; preds = %48, %50, %44
  %62 = add nuw nsw i64 %45, 1
  %63 = icmp eq i64 %62, %19
  br i1 %63, label %47, label %44, !llvm.loop !16

64:                                               ; preds = %46, %64
  %65 = phi i64 [ %90, %64 ], [ 0, %46 ]
  %66 = phi i64 [ %91, %64 ], [ 0, %46 ]
  %67 = mul nsw i64 %65, %18
  %68 = add nuw nsw i64 %67, %45
  %69 = getelementptr inbounds i32, ptr %1, i64 %68
  %70 = load i32, ptr %69, align 4, !tbaa !7
  %71 = getelementptr inbounds i32, ptr %0, i64 %68
  store i32 %70, ptr %71, align 4, !tbaa !7
  %72 = or disjoint i64 %65, 1
  %73 = mul nsw i64 %72, %18
  %74 = add nuw nsw i64 %73, %45
  %75 = getelementptr inbounds i32, ptr %1, i64 %74
  %76 = load i32, ptr %75, align 4, !tbaa !7
  %77 = getelementptr inbounds i32, ptr %0, i64 %74
  store i32 %76, ptr %77, align 4, !tbaa !7
  %78 = or disjoint i64 %65, 2
  %79 = mul nsw i64 %78, %18
  %80 = add nuw nsw i64 %79, %45
  %81 = getelementptr inbounds i32, ptr %1, i64 %80
  %82 = load i32, ptr %81, align 4, !tbaa !7
  %83 = getelementptr inbounds i32, ptr %0, i64 %80
  store i32 %82, ptr %83, align 4, !tbaa !7
  %84 = or disjoint i64 %65, 3
  %85 = mul nsw i64 %84, %18
  %86 = add nuw nsw i64 %85, %45
  %87 = getelementptr inbounds i32, ptr %1, i64 %86
  %88 = load i32, ptr %87, align 4, !tbaa !7
  %89 = getelementptr inbounds i32, ptr %0, i64 %86
  store i32 %88, ptr %89, align 4, !tbaa !7
  %90 = add nuw nsw i64 %65, 4
  %91 = add i64 %66, 4
  %92 = icmp eq i64 %91, %22
  br i1 %92, label %48, label %64, !llvm.loop !17
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read) uwtable
define dso_local i32 @countNeighbors(ptr nocapture noundef readonly %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) local_unnamed_addr #4 {
  %6 = sext i32 %2 to i64
  %7 = sext i32 %3 to i64
  %8 = sext i32 %4 to i64
  %9 = sext i32 %1 to i64
  %10 = add nsw i64 %9, -1
  %11 = icmp sgt i32 %1, 0
  %12 = icmp sle i32 %1, %3
  %13 = add nsw i64 %6, -1
  br i1 %11, label %14, label %49

14:                                               ; preds = %5
  %15 = icmp sgt i32 %2, 0
  %16 = icmp sle i32 %2, %4
  %17 = and i1 %15, %16
  %18 = and i1 %17, %12
  br i1 %18, label %19, label %24

19:                                               ; preds = %14
  %20 = mul nsw i64 %13, %7
  %21 = getelementptr i32, ptr %0, i64 %20
  %22 = getelementptr i32, ptr %21, i64 %10
  %23 = load i32, ptr %22, align 4, !tbaa !7
  br label %24

24:                                               ; preds = %19, %14
  %25 = phi i32 [ 0, %14 ], [ %23, %19 ]
  %26 = icmp sgt i32 %2, -1
  %27 = icmp slt i32 %2, %4
  %28 = and i1 %26, %27
  %29 = and i1 %28, %12
  br i1 %29, label %30, label %36

30:                                               ; preds = %24
  %31 = mul nsw i64 %6, %7
  %32 = getelementptr i32, ptr %0, i64 %31
  %33 = getelementptr i32, ptr %32, i64 %10
  %34 = load i32, ptr %33, align 4, !tbaa !7
  %35 = add nsw i32 %34, %25
  br label %36

36:                                               ; preds = %24, %30
  %37 = phi i32 [ %25, %24 ], [ %35, %30 ]
  %38 = add nsw i64 %6, 1
  %39 = icmp sgt i32 %2, -2
  %40 = and i1 %12, %39
  %41 = icmp slt i64 %38, %8
  %42 = select i1 %40, i1 %41, i1 false
  br i1 %42, label %43, label %51

43:                                               ; preds = %36
  %44 = mul nsw i64 %38, %7
  %45 = getelementptr i32, ptr %0, i64 %44
  %46 = getelementptr i32, ptr %45, i64 %10
  %47 = load i32, ptr %46, align 4, !tbaa !7
  %48 = add nsw i32 %47, %37
  br label %51

49:                                               ; preds = %5
  %50 = icmp sgt i32 %1, -1
  br i1 %50, label %51, label %78

51:                                               ; preds = %43, %36, %49
  %52 = phi i32 [ 0, %49 ], [ %37, %36 ], [ %48, %43 ]
  %53 = icmp slt i32 %1, %3
  %54 = icmp sgt i32 %2, 0
  %55 = icmp sle i32 %2, %4
  %56 = and i1 %54, %55
  %57 = and i1 %56, %53
  br i1 %57, label %58, label %65

58:                                               ; preds = %51
  %59 = add nsw i64 %6, -1
  %60 = mul nsw i64 %59, %7
  %61 = getelementptr i32, ptr %0, i64 %60
  %62 = getelementptr i32, ptr %61, i64 %9
  %63 = load i32, ptr %62, align 4, !tbaa !7
  %64 = add nsw i32 %63, %52
  br label %65

65:                                               ; preds = %51, %58
  %66 = phi i32 [ %64, %58 ], [ %52, %51 ]
  %67 = add nsw i64 %6, 1
  %68 = icmp sgt i32 %2, -2
  %69 = and i1 %53, %68
  %70 = icmp slt i64 %67, %8
  %71 = select i1 %69, i1 %70, i1 false
  br i1 %71, label %72, label %80

72:                                               ; preds = %65
  %73 = mul nsw i64 %67, %7
  %74 = getelementptr i32, ptr %0, i64 %73
  %75 = getelementptr i32, ptr %74, i64 %9
  %76 = load i32, ptr %75, align 4, !tbaa !7
  %77 = add nsw i32 %76, %66
  br label %80

78:                                               ; preds = %49
  %79 = icmp eq i32 %1, -1
  br i1 %79, label %80, label %120

80:                                               ; preds = %72, %65, %78
  %81 = phi i32 [ 0, %78 ], [ %66, %65 ], [ %77, %72 ]
  %82 = add nsw i64 %9, 1
  %83 = icmp slt i64 %82, %7
  %84 = icmp sgt i32 %2, 0
  %85 = icmp sle i32 %2, %4
  %86 = and i1 %84, %85
  %87 = and i1 %86, %83
  br i1 %87, label %88, label %95

88:                                               ; preds = %80
  %89 = add nsw i64 %6, -1
  %90 = mul nsw i64 %89, %7
  %91 = getelementptr i32, ptr %0, i64 %90
  %92 = getelementptr i32, ptr %91, i64 %82
  %93 = load i32, ptr %92, align 4, !tbaa !7
  %94 = add nsw i32 %93, %81
  br label %95

95:                                               ; preds = %80, %88
  %96 = phi i32 [ %94, %88 ], [ %81, %80 ]
  %97 = icmp sgt i32 %2, -1
  %98 = icmp slt i32 %2, %4
  %99 = and i1 %97, %98
  %100 = and i1 %99, %83
  br i1 %100, label %101, label %107

101:                                              ; preds = %95
  %102 = mul nsw i64 %6, %7
  %103 = getelementptr i32, ptr %0, i64 %102
  %104 = getelementptr i32, ptr %103, i64 %82
  %105 = load i32, ptr %104, align 4, !tbaa !7
  %106 = add nsw i32 %105, %96
  br label %107

107:                                              ; preds = %101, %95
  %108 = phi i32 [ %106, %101 ], [ %96, %95 ]
  %109 = add nsw i64 %6, 1
  %110 = icmp sgt i32 %2, -2
  %111 = and i1 %83, %110
  %112 = icmp slt i64 %109, %8
  %113 = select i1 %111, i1 %112, i1 false
  br i1 %113, label %114, label %120

114:                                              ; preds = %107
  %115 = mul nsw i64 %109, %7
  %116 = getelementptr i32, ptr %0, i64 %115
  %117 = getelementptr i32, ptr %116, i64 %82
  %118 = load i32, ptr %117, align 4, !tbaa !7
  %119 = add nsw i32 %118, %108
  br label %120

120:                                              ; preds = %78, %114, %107
  %121 = phi i32 [ %119, %114 ], [ %108, %107 ], [ 0, %78 ]
  ret i32 %121
}

; Function Attrs: nounwind uwtable
define dso_local void @gridDraw(ptr nocapture noundef readonly %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp sgt i32 %1, 0
  br i1 %4, label %5, label %16

5:                                                ; preds = %3
  %6 = icmp sgt i32 %2, 0
  %7 = zext nneg i32 %1 to i64
  %8 = zext nneg i32 %1 to i64
  %9 = zext nneg i32 %2 to i64
  br label %10

10:                                               ; preds = %5, %17
  %11 = phi i64 [ 0, %5 ], [ %18, %17 ]
  br i1 %6, label %12, label %17

12:                                               ; preds = %10
  %13 = getelementptr i32, ptr %0, i64 %11
  %14 = trunc i64 %11 to i32
  %15 = mul i32 %14, 10
  br label %20

16:                                               ; preds = %17, %3
  ret void

17:                                               ; preds = %52, %10
  %18 = add nuw nsw i64 %11, 1
  %19 = icmp eq i64 %18, %8
  br i1 %19, label %16, label %10, !llvm.loop !18

20:                                               ; preds = %12, %52
  %21 = phi i64 [ 0, %12 ], [ %53, %52 ]
  %22 = mul nsw i64 %21, %7
  %23 = getelementptr i32, ptr %13, i64 %22
  %24 = load i32, ptr %23, align 4, !tbaa !7
  %25 = icmp ne i32 %24, 0
  %26 = sext i1 %25 to i32
  %27 = mul nuw nsw i64 %21, 10
  %28 = trunc i64 %27 to i32
  %29 = trunc i64 %27 to i32
  %30 = or disjoint i32 %29, 1
  %31 = trunc i64 %27 to i32
  %32 = add i32 %31, 2
  %33 = trunc i64 %27 to i32
  %34 = add i32 %33, 3
  %35 = trunc i64 %27 to i32
  %36 = add i32 %35, 4
  %37 = trunc i64 %27 to i32
  %38 = add i32 %37, 5
  %39 = trunc i64 %27 to i32
  %40 = add i32 %39, 6
  %41 = trunc i64 %27 to i32
  %42 = add i32 %41, 7
  %43 = trunc i64 %27 to i32
  %44 = add i32 %43, 8
  %45 = trunc i64 %27 to i32
  %46 = add i32 %45, 9
  br label %47

47:                                               ; preds = %20, %47
  %48 = phi i32 [ 0, %20 ], [ %50, %47 ]
  %49 = add nuw nsw i32 %48, %15
  tail call void @simPutPixel(i32 noundef %49, i32 noundef %28, i32 noundef %26) #6
  tail call void @simPutPixel(i32 noundef %49, i32 noundef %30, i32 noundef %26) #6
  tail call void @simPutPixel(i32 noundef %49, i32 noundef %32, i32 noundef %26) #6
  tail call void @simPutPixel(i32 noundef %49, i32 noundef %34, i32 noundef %26) #6
  tail call void @simPutPixel(i32 noundef %49, i32 noundef %36, i32 noundef %26) #6
  tail call void @simPutPixel(i32 noundef %49, i32 noundef %38, i32 noundef %26) #6
  tail call void @simPutPixel(i32 noundef %49, i32 noundef %40, i32 noundef %26) #6
  tail call void @simPutPixel(i32 noundef %49, i32 noundef %42, i32 noundef %26) #6
  tail call void @simPutPixel(i32 noundef %49, i32 noundef %44, i32 noundef %26) #6
  tail call void @simPutPixel(i32 noundef %49, i32 noundef %46, i32 noundef %26) #6
  %50 = add nuw nsw i32 %48, 1
  %51 = icmp eq i32 %50, 10
  br i1 %51, label %52, label %47, !llvm.loop !19

52:                                               ; preds = %47
  %53 = add nuw nsw i64 %21, 1
  %54 = icmp eq i64 %53, %9
  br i1 %54, label %17, label %20, !llvm.loop !20
}

declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: noreturn nounwind uwtable
define dso_local void @app() local_unnamed_addr #5 {
  %1 = alloca [4800 x i32], align 16
  %2 = alloca [4800 x i32], align 16
  call void @llvm.lifetime.start.p0(i64 19200, ptr nonnull %1) #6
  call void @llvm.lifetime.start.p0(i64 19200, ptr nonnull %2) #6
  br label %3

3:                                                ; preds = %6, %0
  %4 = phi i64 [ 0, %0 ], [ %7, %6 ]
  %5 = getelementptr i32, ptr %1, i64 %4
  br label %9

6:                                                ; preds = %9
  %7 = add nuw nsw i64 %4, 1
  %8 = icmp eq i64 %7, 80
  br i1 %8, label %17, label %3, !llvm.loop !5

9:                                                ; preds = %9, %3
  %10 = phi i64 [ 0, %3 ], [ %15, %9 ]
  %11 = tail call i32 (...) @simRand() #6
  %12 = srem i32 %11, 2
  %13 = mul nuw nsw i64 %10, 80
  %14 = getelementptr i32, ptr %5, i64 %13
  store i32 %12, ptr %14, align 4, !tbaa !7
  %15 = add nuw nsw i64 %10, 1
  %16 = icmp eq i64 %15, 60
  br i1 %16, label %6, label %9, !llvm.loop !11

17:                                               ; preds = %6, %23
  %18 = phi i64 [ %24, %23 ], [ 0, %6 ]
  %19 = trunc i64 %18 to i32
  br label %25

20:                                               ; preds = %25
  %21 = add nuw nsw i64 %18, 1
  %22 = icmp eq i64 %21, 80
  br i1 %22, label %42, label %23

23:                                               ; preds = %20, %74
  %24 = phi i64 [ %21, %20 ], [ 0, %74 ]
  br label %17, !llvm.loop !12

25:                                               ; preds = %25, %17
  %26 = phi i64 [ 0, %17 ], [ %40, %25 ]
  %27 = trunc i64 %26 to i32
  %28 = call i32 @countNeighbors(ptr noundef nonnull %1, i32 noundef %19, i32 noundef %27, i32 noundef 80, i32 noundef 60)
  %29 = mul nuw nsw i64 %26, 80
  %30 = add nuw nsw i64 %29, %18
  %31 = getelementptr inbounds i32, ptr %1, i64 %30
  %32 = load i32, ptr %31, align 4, !tbaa !7
  %33 = icmp eq i32 %32, 1
  %34 = and i32 %28, -2
  %35 = icmp eq i32 %34, 2
  %36 = icmp eq i32 %28, 3
  %37 = select i1 %33, i1 %35, i1 %36
  %38 = zext i1 %37 to i32
  %39 = getelementptr inbounds i32, ptr %2, i64 %30
  store i32 %38, ptr %39, align 4
  %40 = add nuw nsw i64 %26, 1
  %41 = icmp eq i64 %40, 60
  br i1 %41, label %20, label %25, !llvm.loop !13

42:                                               ; preds = %20, %44
  %43 = phi i64 [ %45, %44 ], [ 0, %20 ]
  br label %47

44:                                               ; preds = %47
  %45 = add nuw nsw i64 %43, 1
  %46 = icmp eq i64 %45, 80
  br i1 %46, label %74, label %42, !llvm.loop !16

47:                                               ; preds = %47, %42
  %48 = phi i64 [ 0, %42 ], [ %72, %47 ]
  %49 = mul nuw nsw i64 %48, 80
  %50 = add nuw nsw i64 %49, %43
  %51 = getelementptr inbounds i32, ptr %2, i64 %50
  %52 = load i32, ptr %51, align 4, !tbaa !7
  %53 = getelementptr inbounds i32, ptr %1, i64 %50
  store i32 %52, ptr %53, align 4, !tbaa !7
  %54 = mul nuw i64 %48, 80
  %55 = add nuw i64 %54, 80
  %56 = add nuw nsw i64 %55, %43
  %57 = getelementptr inbounds i32, ptr %2, i64 %56
  %58 = load i32, ptr %57, align 4, !tbaa !7
  %59 = getelementptr inbounds i32, ptr %1, i64 %56
  store i32 %58, ptr %59, align 4, !tbaa !7
  %60 = mul nuw i64 %48, 80
  %61 = add nuw i64 %60, 160
  %62 = add nuw nsw i64 %61, %43
  %63 = getelementptr inbounds i32, ptr %2, i64 %62
  %64 = load i32, ptr %63, align 4, !tbaa !7
  %65 = getelementptr inbounds i32, ptr %1, i64 %62
  store i32 %64, ptr %65, align 4, !tbaa !7
  %66 = mul nuw i64 %48, 80
  %67 = add nuw i64 %66, 240
  %68 = add nuw nsw i64 %67, %43
  %69 = getelementptr inbounds i32, ptr %2, i64 %68
  %70 = load i32, ptr %69, align 4, !tbaa !7
  %71 = getelementptr inbounds i32, ptr %1, i64 %68
  store i32 %70, ptr %71, align 4, !tbaa !7
  %72 = add nuw nsw i64 %48, 4
  %73 = icmp eq i64 %72, 60
  br i1 %73, label %44, label %47, !llvm.loop !17

74:                                               ; preds = %44
  call void @gridDraw(ptr noundef nonnull %1, i32 noundef 80, i32 noundef 60)
  tail call void (...) @simFlush() #6
  br label %23
}

declare void @simFlush(...) local_unnamed_addr #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!8, !8, i64 0}
!8 = !{!"int", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = distinct !{!11, !6}
!12 = distinct !{!12, !6}
!13 = distinct !{!13, !6}
!14 = distinct !{!14, !15}
!15 = !{!"llvm.loop.unroll.disable"}
!16 = distinct !{!16, !6}
!17 = distinct !{!17, !6}
!18 = distinct !{!18, !6}
!19 = distinct !{!19, !6}
!20 = distinct !{!20, !6}
