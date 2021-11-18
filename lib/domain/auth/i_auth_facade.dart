
import 'package:fpdart/fpdart.dart';
import 'package:try_ddd/domain/auth/value_objects.dart';

import 'auth_failure.dart';

abstract class IAuthFacade {
  
  //三个主要函数，异步的实现在repo层，返回是void，考虑到异常
  //返回一个Either，left是错误，right 用unit代替void表示返回空，类型的原因
  //各种错误也用freezed union 来实现
  //repo实现层会把所以异常转换为这里返回值中的left错误类型
  //email和password的错误是一种安全数据类型中的错误，这里的错误是api错误
  
  //之所以用unit来代表成功是我们不打算要api调用成功的返回值
  //在这一层我们用EmailAddress,Password的类型来调用api，表示调用的时候我们会保证他们的right
  //如何他们left，该抛出异常了，说明写的逻辑有问题了
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();
  Future<void> signOut();
}
