; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals none --version 5
; RUN: opt -p loop-vectorize -S %s | FileCheck --check-prefixes=CHECK %s

target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

define void @test_add_double_same_const_args_1(ptr %res, ptr noalias %A, ptr noalias %B) {
; CHECK-LABEL: define void @test_add_double_same_const_args_1(
; CHECK-SAME: ptr [[RES:%.*]], ptr noalias [[A:%.*]], ptr noalias [[B:%.*]]) {
; CHECK-NEXT:  [[ENTRY:.*]]:
; CHECK-NEXT:    br i1 false, label %[[SCALAR_PH:.*]], label %[[VECTOR_PH:.*]]
; CHECK:       [[VECTOR_PH]]:
; CHECK-NEXT:    br label %[[VECTOR_BODY:.*]]
; CHECK:       [[VECTOR_BODY]]:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, %[[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], %[[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[A]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[A]], i64 [[TMP1]]
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <4 x double>, ptr [[TMP2]], align 4
; CHECK-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <4 x double> [[WIDE_VEC]], <4 x double> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[STRIDED_VEC1:%.*]] = shufflevector <4 x double> [[WIDE_VEC]], <4 x double> poison, <2 x i32> <i32 1, i32 3>
; CHECK-NEXT:    [[WIDE_VEC2:%.*]] = load <4 x double>, ptr [[TMP3]], align 4
; CHECK-NEXT:    [[STRIDED_VEC3:%.*]] = shufflevector <4 x double> [[WIDE_VEC2]], <4 x double> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[STRIDED_VEC4:%.*]] = shufflevector <4 x double> [[WIDE_VEC2]], <4 x double> poison, <2 x i32> <i32 1, i32 3>
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <2 x double> [[STRIDED_VEC]], splat (double 1.000000e+00)
; CHECK-NEXT:    [[TMP5:%.*]] = fadd <2 x double> [[STRIDED_VEC3]], splat (double 1.000000e+00)
; CHECK-NEXT:    [[TMP6:%.*]] = fadd <2 x double> [[STRIDED_VEC1]], splat (double 1.000000e+00)
; CHECK-NEXT:    [[TMP7:%.*]] = fadd <2 x double> [[STRIDED_VEC4]], splat (double 1.000000e+00)
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[RES]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[RES]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <2 x double> [[TMP4]], <2 x double> [[TMP6]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[INTERLEAVED_VEC:%.*]] = shufflevector <4 x double> [[TMP10]], <4 x double> poison, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
; CHECK-NEXT:    store <4 x double> [[INTERLEAVED_VEC]], ptr [[TMP8]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <2 x double> [[TMP5]], <2 x double> [[TMP7]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[INTERLEAVED_VEC5:%.*]] = shufflevector <4 x double> [[TMP11]], <4 x double> poison, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
; CHECK-NEXT:    store <4 x double> [[INTERLEAVED_VEC5]], ptr [[TMP9]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq i64 [[INDEX_NEXT]], 100
; CHECK-NEXT:    br i1 [[TMP12]], label %[[MIDDLE_BLOCK:.*]], label %[[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       [[MIDDLE_BLOCK]]:
; CHECK-NEXT:    br i1 true, label %[[EXIT:.*]], label %[[SCALAR_PH]]
; CHECK:       [[SCALAR_PH]]:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 100, %[[MIDDLE_BLOCK]] ], [ 0, %[[ENTRY]] ]
; CHECK-NEXT:    br label %[[LOOP:.*]]
; CHECK:       [[LOOP]]:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], %[[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], %[[LOOP]] ]
; CHECK-NEXT:    [[GEP_A_0:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[A]], i64 [[IV]]
; CHECK-NEXT:    [[L_A_0:%.*]] = load double, ptr [[GEP_A_0]], align 4
; CHECK-NEXT:    [[GEP_A_1:%.*]] = getelementptr inbounds nuw i8, ptr [[GEP_A_0]], i64 8
; CHECK-NEXT:    [[L_A_1:%.*]] = load double, ptr [[GEP_A_1]], align 4
; CHECK-NEXT:    [[ADD_0:%.*]] = fadd double [[L_A_0]], 1.000000e+00
; CHECK-NEXT:    [[ADD_1:%.*]] = fadd double [[L_A_1]], 1.000000e+00
; CHECK-NEXT:    [[GEP_RES_0:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[RES]], i64 [[IV]]
; CHECK-NEXT:    store double [[ADD_0]], ptr [[GEP_RES_0]], align 4
; CHECK-NEXT:    [[GEP_RES_1:%.*]] = getelementptr inbounds nuw i8, ptr [[GEP_RES_0]], i64 8
; CHECK-NEXT:    store double [[ADD_1]], ptr [[GEP_RES_1]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EC:%.*]] = icmp eq i64 [[IV_NEXT]], 100
; CHECK-NEXT:    br i1 [[EC]], label %[[EXIT]], label %[[LOOP]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       [[EXIT]]:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.A.0 = getelementptr inbounds nuw { double, double }, ptr %A, i64 %iv
  %l.A.0 = load double, ptr %gep.A.0, align 4
  %gep.A.1 = getelementptr inbounds nuw i8, ptr %gep.A.0, i64 8
  %l.A.1 = load double, ptr %gep.A.1, align 4
  %add.0 = fadd double %l.A.0, 1.0
  %add.1 = fadd double %l.A.1, 1.0
  %gep.res.0 = getelementptr inbounds nuw { double, double }, ptr %res, i64 %iv
  store double %add.0, ptr %gep.res.0, align 4
  %gep.res.1 = getelementptr inbounds nuw i8, ptr %gep.res.0, i64 8
  store double %add.1, ptr %gep.res.1, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %ec = icmp eq i64 %iv.next, 100
  br i1 %ec, label %exit, label %loop

exit:
  ret void
}

define void @test_add_double_same_const_args_2(ptr %res, ptr noalias %A, ptr noalias %B) {
; CHECK-LABEL: define void @test_add_double_same_const_args_2(
; CHECK-SAME: ptr [[RES:%.*]], ptr noalias [[A:%.*]], ptr noalias [[B:%.*]]) {
; CHECK-NEXT:  [[ENTRY:.*]]:
; CHECK-NEXT:    br i1 false, label %[[SCALAR_PH:.*]], label %[[VECTOR_PH:.*]]
; CHECK:       [[VECTOR_PH]]:
; CHECK-NEXT:    br label %[[VECTOR_BODY:.*]]
; CHECK:       [[VECTOR_BODY]]:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, %[[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], %[[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[B]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[B]], i64 [[TMP1]]
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <4 x double>, ptr [[TMP2]], align 4
; CHECK-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <4 x double> [[WIDE_VEC]], <4 x double> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[STRIDED_VEC1:%.*]] = shufflevector <4 x double> [[WIDE_VEC]], <4 x double> poison, <2 x i32> <i32 1, i32 3>
; CHECK-NEXT:    [[WIDE_VEC2:%.*]] = load <4 x double>, ptr [[TMP3]], align 4
; CHECK-NEXT:    [[STRIDED_VEC3:%.*]] = shufflevector <4 x double> [[WIDE_VEC2]], <4 x double> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[STRIDED_VEC4:%.*]] = shufflevector <4 x double> [[WIDE_VEC2]], <4 x double> poison, <2 x i32> <i32 1, i32 3>
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <2 x double> splat (double 1.000000e+00), [[STRIDED_VEC]]
; CHECK-NEXT:    [[TMP5:%.*]] = fadd <2 x double> splat (double 1.000000e+00), [[STRIDED_VEC3]]
; CHECK-NEXT:    [[TMP6:%.*]] = fadd <2 x double> splat (double 1.000000e+00), [[STRIDED_VEC1]]
; CHECK-NEXT:    [[TMP7:%.*]] = fadd <2 x double> splat (double 1.000000e+00), [[STRIDED_VEC4]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[RES]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[RES]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <2 x double> [[TMP4]], <2 x double> [[TMP6]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[INTERLEAVED_VEC:%.*]] = shufflevector <4 x double> [[TMP10]], <4 x double> poison, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
; CHECK-NEXT:    store <4 x double> [[INTERLEAVED_VEC]], ptr [[TMP8]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <2 x double> [[TMP5]], <2 x double> [[TMP7]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[INTERLEAVED_VEC5:%.*]] = shufflevector <4 x double> [[TMP11]], <4 x double> poison, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
; CHECK-NEXT:    store <4 x double> [[INTERLEAVED_VEC5]], ptr [[TMP9]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq i64 [[INDEX_NEXT]], 100
; CHECK-NEXT:    br i1 [[TMP12]], label %[[MIDDLE_BLOCK:.*]], label %[[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       [[MIDDLE_BLOCK]]:
; CHECK-NEXT:    br i1 true, label %[[EXIT:.*]], label %[[SCALAR_PH]]
; CHECK:       [[SCALAR_PH]]:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 100, %[[MIDDLE_BLOCK]] ], [ 0, %[[ENTRY]] ]
; CHECK-NEXT:    br label %[[LOOP:.*]]
; CHECK:       [[LOOP]]:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], %[[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], %[[LOOP]] ]
; CHECK-NEXT:    [[GEP_B_0:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[B]], i64 [[IV]]
; CHECK-NEXT:    [[L_B_0:%.*]] = load double, ptr [[GEP_B_0]], align 4
; CHECK-NEXT:    [[ADD_0:%.*]] = fadd double 1.000000e+00, [[L_B_0]]
; CHECK-NEXT:    [[GEP_B_1:%.*]] = getelementptr inbounds nuw i8, ptr [[GEP_B_0]], i64 8
; CHECK-NEXT:    [[L_B_1:%.*]] = load double, ptr [[GEP_B_1]], align 4
; CHECK-NEXT:    [[ADD_1:%.*]] = fadd double 1.000000e+00, [[L_B_1]]
; CHECK-NEXT:    [[GEP_RES_0:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[RES]], i64 [[IV]]
; CHECK-NEXT:    store double [[ADD_0]], ptr [[GEP_RES_0]], align 4
; CHECK-NEXT:    [[GEP_RES_1:%.*]] = getelementptr inbounds nuw i8, ptr [[GEP_RES_0]], i64 8
; CHECK-NEXT:    store double [[ADD_1]], ptr [[GEP_RES_1]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EC:%.*]] = icmp eq i64 [[IV_NEXT]], 100
; CHECK-NEXT:    br i1 [[EC]], label %[[EXIT]], label %[[LOOP]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       [[EXIT]]:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.B.0 = getelementptr inbounds nuw { double, double }, ptr %B, i64 %iv
  %l.B.0 = load double, ptr %gep.B.0, align 4
  %add.0 = fadd double 1.0, %l.B.0
  %gep.B.1 = getelementptr inbounds nuw i8, ptr %gep.B.0, i64 8
  %l.B.1 = load double, ptr %gep.B.1, align 4
  %add.1 = fadd double 1.0, %l.B.1
  %gep.res.0 = getelementptr inbounds nuw { double, double }, ptr %res, i64 %iv
  store double %add.0, ptr %gep.res.0, align 4
  %gep.res.1 = getelementptr inbounds nuw i8, ptr %gep.res.0, i64 8
  store double %add.1, ptr %gep.res.1, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %ec = icmp eq i64 %iv.next, 100
  br i1 %ec, label %exit, label %loop

exit:
  ret void
}

define void @test_add_double_mixed_const_args(ptr %res, ptr noalias %A, ptr noalias %B) {
; CHECK-LABEL: define void @test_add_double_mixed_const_args(
; CHECK-SAME: ptr [[RES:%.*]], ptr noalias [[A:%.*]], ptr noalias [[B:%.*]]) {
; CHECK-NEXT:  [[ENTRY:.*]]:
; CHECK-NEXT:    br i1 false, label %[[SCALAR_PH:.*]], label %[[VECTOR_PH:.*]]
; CHECK:       [[VECTOR_PH]]:
; CHECK-NEXT:    br label %[[VECTOR_BODY:.*]]
; CHECK:       [[VECTOR_BODY]]:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, %[[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], %[[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[B]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[B]], i64 [[TMP1]]
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <4 x double>, ptr [[TMP2]], align 4
; CHECK-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <4 x double> [[WIDE_VEC]], <4 x double> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[STRIDED_VEC1:%.*]] = shufflevector <4 x double> [[WIDE_VEC]], <4 x double> poison, <2 x i32> <i32 1, i32 3>
; CHECK-NEXT:    [[WIDE_VEC2:%.*]] = load <4 x double>, ptr [[TMP3]], align 4
; CHECK-NEXT:    [[STRIDED_VEC3:%.*]] = shufflevector <4 x double> [[WIDE_VEC2]], <4 x double> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[STRIDED_VEC4:%.*]] = shufflevector <4 x double> [[WIDE_VEC2]], <4 x double> poison, <2 x i32> <i32 1, i32 3>
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <2 x double> splat (double 1.000000e+00), [[STRIDED_VEC]]
; CHECK-NEXT:    [[TMP5:%.*]] = fadd <2 x double> splat (double 1.000000e+00), [[STRIDED_VEC3]]
; CHECK-NEXT:    [[TMP6:%.*]] = fadd <2 x double> splat (double 2.000000e+00), [[STRIDED_VEC1]]
; CHECK-NEXT:    [[TMP7:%.*]] = fadd <2 x double> splat (double 2.000000e+00), [[STRIDED_VEC4]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[RES]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[RES]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <2 x double> [[TMP4]], <2 x double> [[TMP6]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[INTERLEAVED_VEC:%.*]] = shufflevector <4 x double> [[TMP10]], <4 x double> poison, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
; CHECK-NEXT:    store <4 x double> [[INTERLEAVED_VEC]], ptr [[TMP8]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <2 x double> [[TMP5]], <2 x double> [[TMP7]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[INTERLEAVED_VEC5:%.*]] = shufflevector <4 x double> [[TMP11]], <4 x double> poison, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
; CHECK-NEXT:    store <4 x double> [[INTERLEAVED_VEC5]], ptr [[TMP9]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq i64 [[INDEX_NEXT]], 100
; CHECK-NEXT:    br i1 [[TMP12]], label %[[MIDDLE_BLOCK:.*]], label %[[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       [[MIDDLE_BLOCK]]:
; CHECK-NEXT:    br i1 true, label %[[EXIT:.*]], label %[[SCALAR_PH]]
; CHECK:       [[SCALAR_PH]]:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 100, %[[MIDDLE_BLOCK]] ], [ 0, %[[ENTRY]] ]
; CHECK-NEXT:    br label %[[LOOP:.*]]
; CHECK:       [[LOOP]]:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], %[[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], %[[LOOP]] ]
; CHECK-NEXT:    [[GEP_B_0:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[B]], i64 [[IV]]
; CHECK-NEXT:    [[L_B_0:%.*]] = load double, ptr [[GEP_B_0]], align 4
; CHECK-NEXT:    [[ADD_0:%.*]] = fadd double 1.000000e+00, [[L_B_0]]
; CHECK-NEXT:    [[GEP_B_1:%.*]] = getelementptr inbounds nuw i8, ptr [[GEP_B_0]], i64 8
; CHECK-NEXT:    [[L_B_1:%.*]] = load double, ptr [[GEP_B_1]], align 4
; CHECK-NEXT:    [[ADD_1:%.*]] = fadd double 2.000000e+00, [[L_B_1]]
; CHECK-NEXT:    [[GEP_RES_0:%.*]] = getelementptr inbounds nuw { double, double }, ptr [[RES]], i64 [[IV]]
; CHECK-NEXT:    store double [[ADD_0]], ptr [[GEP_RES_0]], align 4
; CHECK-NEXT:    [[GEP_RES_1:%.*]] = getelementptr inbounds nuw i8, ptr [[GEP_RES_0]], i64 8
; CHECK-NEXT:    store double [[ADD_1]], ptr [[GEP_RES_1]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EC:%.*]] = icmp eq i64 [[IV_NEXT]], 100
; CHECK-NEXT:    br i1 [[EC]], label %[[EXIT]], label %[[LOOP]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       [[EXIT]]:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.B.0 = getelementptr inbounds nuw { double, double }, ptr %B, i64 %iv
  %l.B.0 = load double, ptr %gep.B.0, align 4
  %add.0 = fadd double 1.0, %l.B.0
  %gep.B.1 = getelementptr inbounds nuw i8, ptr %gep.B.0, i64 8
  %l.B.1 = load double, ptr %gep.B.1, align 4
  %add.1 = fadd double 2.0, %l.B.1
  %gep.res.0 = getelementptr inbounds nuw { double, double }, ptr %res, i64 %iv
  store double %add.0, ptr %gep.res.0, align 4
  %gep.res.1 = getelementptr inbounds nuw i8, ptr %gep.res.0, i64 8
  store double %add.1, ptr %gep.res.1, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %ec = icmp eq i64 %iv.next, 100
  br i1 %ec, label %exit, label %loop

exit:
  ret void
}
