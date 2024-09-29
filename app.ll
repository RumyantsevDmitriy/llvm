; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@grid = internal unnamed_addr global [80 x [60 x i32]] zeroinitializer, align 16
@next_grid = internal unnamed_addr global [80 x [60 x i32]] zeroinitializer, align 16

; Function Attrs: nounwind uwtable
define dso_local void @gridInit() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %0, %4
  %2 = phi i64 [ 0, %0 ], [ %5, %4 ]
  br label %7

3:                                                ; preds = %4
  ret void

4:                                                ; preds = %7
  %5 = add nuw nsw i64 %2, 1
  %6 = icmp eq i64 %5, 80
  br i1 %6, label %3, label %1, !llvm.loop !5

7:                                                ; preds = %1, %7
  %8 = phi i64 [ 0, %1 ], [ %12, %7 ]
  %9 = tail call i32 (...) @simRand() #6
  %10 = srem i32 %9, 2
  %11 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %2, i64 %8
  store i32 %10, ptr %11, align 4, !tbaa !7
  %12 = add nuw nsw i64 %8, 1
  %13 = icmp eq i64 %12, 60
  br i1 %13, label %4, label %7, !llvm.loop !11
}

declare i32 @simRand(...) local_unnamed_addr #1

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, argmem: read, inaccessiblemem: none) uwtable
define dso_local void @gridUpdate() local_unnamed_addr #2 {
  br label %1

1:                                                ; preds = %0, %4
  %2 = phi i64 [ 0, %0 ], [ %5, %4 ]
  %3 = trunc i64 %2 to i32
  br label %8

4:                                                ; preds = %8
  %5 = add nuw nsw i64 %2, 1
  %6 = icmp eq i64 %5, 80
  br i1 %6, label %7, label %1, !llvm.loop !12

7:                                                ; preds = %4
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(19200) @grid, ptr noundef nonnull align 16 dereferenceable(19200) @next_grid, i64 19200, i1 false), !tbaa !7
  ret void

8:                                                ; preds = %1, %8
  %9 = phi i64 [ 0, %1 ], [ %21, %8 ]
  %10 = trunc i64 %9 to i32
  %11 = tail call i32 @countNeighbors(i32 noundef %3, i32 noundef %10)
  %12 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %2, i64 %9
  %13 = load i32, ptr %12, align 4, !tbaa !7
  %14 = icmp eq i32 %13, 1
  %15 = and i32 %11, -2
  %16 = icmp eq i32 %15, 2
  %17 = icmp eq i32 %11, 3
  %18 = select i1 %14, i1 %16, i1 %17
  %19 = zext i1 %18 to i32
  %20 = getelementptr inbounds [80 x [60 x i32]], ptr @next_grid, i64 0, i64 %2, i64 %9
  store i32 %19, ptr %20, align 4
  %21 = add nuw nsw i64 %9, 1
  %22 = icmp eq i64 %21, 60
  br i1 %22, label %4, label %8, !llvm.loop !13
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(read, argmem: none, inaccessiblemem: none) uwtable
define dso_local i32 @countNeighbors(i32 noundef %0, i32 noundef %1) local_unnamed_addr #3 {
  %3 = add nsw i32 %0, -1
  %4 = icmp ult i32 %3, 80
  %5 = zext nneg i32 %3 to i64
  %6 = add i32 %1, -1
  %7 = icmp ult i32 %6, 60
  %8 = and i1 %4, %7
  br i1 %8, label %9, label %14

9:                                                ; preds = %2
  %10 = add nsw i32 %1, -1
  %11 = zext nneg i32 %10 to i64
  %12 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %5, i64 %11
  %13 = load i32, ptr %12, align 4, !tbaa !7
  br label %14

14:                                               ; preds = %9, %2
  %15 = phi i32 [ %13, %9 ], [ 0, %2 ]
  %16 = icmp ult i32 %1, 60
  %17 = and i1 %4, %16
  br i1 %17, label %18, label %23

18:                                               ; preds = %14
  %19 = zext nneg i32 %1 to i64
  %20 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %5, i64 %19
  %21 = load i32, ptr %20, align 4, !tbaa !7
  %22 = add nsw i32 %21, %15
  br label %23

23:                                               ; preds = %14, %18
  %24 = phi i32 [ %22, %18 ], [ %15, %14 ]
  %25 = add i32 %1, 1
  %26 = icmp ult i32 %25, 60
  %27 = and i1 %4, %26
  br i1 %27, label %28, label %34

28:                                               ; preds = %23
  %29 = add nsw i32 %1, 1
  %30 = zext nneg i32 %29 to i64
  %31 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %5, i64 %30
  %32 = load i32, ptr %31, align 4, !tbaa !7
  %33 = add nsw i32 %32, %24
  br label %34

34:                                               ; preds = %23, %28
  %35 = phi i32 [ %33, %28 ], [ %24, %23 ]
  %36 = icmp ult i32 %0, 80
  %37 = zext nneg i32 %0 to i64
  %38 = add i32 %1, -1
  %39 = icmp ult i32 %38, 60
  %40 = and i1 %36, %39
  br i1 %40, label %41, label %47

41:                                               ; preds = %34
  %42 = add nsw i32 %1, -1
  %43 = zext nneg i32 %42 to i64
  %44 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %37, i64 %43
  %45 = load i32, ptr %44, align 4, !tbaa !7
  %46 = add nsw i32 %45, %35
  br label %47

47:                                               ; preds = %41, %34
  %48 = phi i32 [ %46, %41 ], [ %35, %34 ]
  %49 = add i32 %1, 1
  %50 = icmp ult i32 %49, 60
  %51 = and i1 %36, %50
  br i1 %51, label %52, label %58

52:                                               ; preds = %47
  %53 = add nsw i32 %1, 1
  %54 = zext nneg i32 %53 to i64
  %55 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %37, i64 %54
  %56 = load i32, ptr %55, align 4, !tbaa !7
  %57 = add nsw i32 %56, %48
  br label %58

58:                                               ; preds = %47, %52
  %59 = phi i32 [ %57, %52 ], [ %48, %47 ]
  %60 = add nsw i32 %0, 1
  %61 = icmp ult i32 %60, 80
  %62 = zext nneg i32 %60 to i64
  %63 = add i32 %1, -1
  %64 = icmp ult i32 %63, 60
  %65 = and i1 %61, %64
  br i1 %65, label %66, label %72

66:                                               ; preds = %58
  %67 = add nsw i32 %1, -1
  %68 = zext nneg i32 %67 to i64
  %69 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %62, i64 %68
  %70 = load i32, ptr %69, align 4, !tbaa !7
  %71 = add nsw i32 %70, %59
  br label %72

72:                                               ; preds = %58, %66
  %73 = phi i32 [ %71, %66 ], [ %59, %58 ]
  %74 = icmp ult i32 %1, 60
  %75 = and i1 %61, %74
  br i1 %75, label %76, label %81

76:                                               ; preds = %72
  %77 = zext nneg i32 %1 to i64
  %78 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %62, i64 %77
  %79 = load i32, ptr %78, align 4, !tbaa !7
  %80 = add nsw i32 %79, %73
  br label %81

81:                                               ; preds = %72, %76
  %82 = phi i32 [ %80, %76 ], [ %73, %72 ]
  %83 = add i32 %1, 1
  %84 = icmp ult i32 %83, 60
  %85 = and i1 %61, %84
  br i1 %85, label %86, label %92

86:                                               ; preds = %81
  %87 = add nsw i32 %1, 1
  %88 = zext nneg i32 %87 to i64
  %89 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %62, i64 %88
  %90 = load i32, ptr %89, align 4, !tbaa !7
  %91 = add nsw i32 %90, %82
  br label %92

92:                                               ; preds = %86, %81
  %93 = phi i32 [ %91, %86 ], [ %82, %81 ]
  ret i32 %93
}

; Function Attrs: nounwind uwtable
define dso_local void @gridDraw() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %0, %6
  %2 = phi i64 [ 0, %0 ], [ %7, %6 ]
  %3 = trunc i64 %2 to i32
  %4 = mul i32 %3, 10
  br label %9

5:                                                ; preds = %6
  ret void

6:                                                ; preds = %40
  %7 = add nuw nsw i64 %2, 1
  %8 = icmp eq i64 %7, 80
  br i1 %8, label %5, label %1, !llvm.loop !14

9:                                                ; preds = %1, %40
  %10 = phi i64 [ 0, %1 ], [ %41, %40 ]
  %11 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %2, i64 %10
  %12 = load i32, ptr %11, align 4, !tbaa !7
  %13 = icmp ne i32 %12, 0
  %14 = sext i1 %13 to i32
  %15 = mul nuw nsw i64 %10, 10
  %16 = trunc i64 %15 to i32
  %17 = trunc i64 %15 to i32
  %18 = or disjoint i32 %17, 1
  %19 = trunc i64 %15 to i32
  %20 = add i32 %19, 2
  %21 = trunc i64 %15 to i32
  %22 = add i32 %21, 3
  %23 = trunc i64 %15 to i32
  %24 = add i32 %23, 4
  %25 = trunc i64 %15 to i32
  %26 = add i32 %25, 5
  %27 = trunc i64 %15 to i32
  %28 = add i32 %27, 6
  %29 = trunc i64 %15 to i32
  %30 = add i32 %29, 7
  %31 = trunc i64 %15 to i32
  %32 = add i32 %31, 8
  %33 = trunc i64 %15 to i32
  %34 = add i32 %33, 9
  br label %35

35:                                               ; preds = %9, %35
  %36 = phi i32 [ 0, %9 ], [ %38, %35 ]
  %37 = add nuw nsw i32 %36, %4
  tail call void @simPutPixel(i32 noundef %37, i32 noundef %16, i32 noundef %14) #6
  tail call void @simPutPixel(i32 noundef %37, i32 noundef %18, i32 noundef %14) #6
  tail call void @simPutPixel(i32 noundef %37, i32 noundef %20, i32 noundef %14) #6
  tail call void @simPutPixel(i32 noundef %37, i32 noundef %22, i32 noundef %14) #6
  tail call void @simPutPixel(i32 noundef %37, i32 noundef %24, i32 noundef %14) #6
  tail call void @simPutPixel(i32 noundef %37, i32 noundef %26, i32 noundef %14) #6
  tail call void @simPutPixel(i32 noundef %37, i32 noundef %28, i32 noundef %14) #6
  tail call void @simPutPixel(i32 noundef %37, i32 noundef %30, i32 noundef %14) #6
  tail call void @simPutPixel(i32 noundef %37, i32 noundef %32, i32 noundef %14) #6
  tail call void @simPutPixel(i32 noundef %37, i32 noundef %34, i32 noundef %14) #6
  %38 = add nuw nsw i32 %36, 1
  %39 = icmp eq i32 %38, 10
  br i1 %39, label %40, label %35, !llvm.loop !15

40:                                               ; preds = %35
  %41 = add nuw nsw i64 %10, 1
  %42 = icmp eq i64 %41, 60
  br i1 %42, label %6, label %9, !llvm.loop !16
}

declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: noreturn nounwind uwtable
define dso_local void @app() local_unnamed_addr #4 {
  br label %1

1:                                                ; preds = %3, %0
  %2 = phi i64 [ 0, %0 ], [ %4, %3 ]
  br label %6

3:                                                ; preds = %6
  %4 = add nuw nsw i64 %2, 1
  %5 = icmp eq i64 %4, 80
  br i1 %5, label %13, label %1, !llvm.loop !5

6:                                                ; preds = %6, %1
  %7 = phi i64 [ 0, %1 ], [ %11, %6 ]
  %8 = tail call i32 (...) @simRand() #6
  %9 = srem i32 %8, 2
  %10 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %2, i64 %7
  store i32 %9, ptr %10, align 4, !tbaa !7
  %11 = add nuw nsw i64 %7, 1
  %12 = icmp eq i64 %11, 60
  br i1 %12, label %3, label %6, !llvm.loop !11

13:                                               ; preds = %3, %19
  %14 = phi i64 [ %20, %19 ], [ 0, %3 ]
  %15 = trunc i64 %14 to i32
  br label %21

16:                                               ; preds = %21
  %17 = add nuw nsw i64 %14, 1
  %18 = icmp eq i64 %17, 80
  br i1 %18, label %36, label %19

19:                                               ; preds = %16, %36
  %20 = phi i64 [ %17, %16 ], [ 0, %36 ]
  br label %13, !llvm.loop !12

21:                                               ; preds = %21, %13
  %22 = phi i64 [ 0, %13 ], [ %34, %21 ]
  %23 = trunc i64 %22 to i32
  %24 = tail call i32 @countNeighbors(i32 noundef %15, i32 noundef %23)
  %25 = getelementptr inbounds [80 x [60 x i32]], ptr @grid, i64 0, i64 %14, i64 %22
  %26 = load i32, ptr %25, align 4, !tbaa !7
  %27 = icmp eq i32 %26, 1
  %28 = and i32 %24, -2
  %29 = icmp eq i32 %28, 2
  %30 = icmp eq i32 %24, 3
  %31 = select i1 %27, i1 %29, i1 %30
  %32 = zext i1 %31 to i32
  %33 = getelementptr inbounds [80 x [60 x i32]], ptr @next_grid, i64 0, i64 %14, i64 %22
  store i32 %32, ptr %33, align 4
  %34 = add nuw nsw i64 %22, 1
  %35 = icmp eq i64 %34, 60
  br i1 %35, label %16, label %21, !llvm.loop !13

36:                                               ; preds = %16
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(19200) @grid, ptr noundef nonnull align 16 dereferenceable(19200) @next_grid, i64 19200, i1 false), !tbaa !7
  tail call void @gridDraw()
  tail call void (...) @simFlush() #6
  br label %19
}

declare void @simFlush(...) local_unnamed_addr #1

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #5

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree norecurse nosync nounwind memory(readwrite, argmem: read, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nofree norecurse nosync nounwind willreturn memory(read, argmem: none, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
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
!14 = distinct !{!14, !6}
!15 = distinct !{!15, !6}
!16 = distinct !{!16, !6}
