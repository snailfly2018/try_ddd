## Which actions do we need to perform on the authentication backend? There are three things, which we will translate into methods.

. Register with email and password
. Sign in with email and password
. Sign in with Google

Let us, therefore, create i_auth_facade.dart under domain/auth. Its methods will take in EmailAddress and Password value objects we created in the previous part. The "i" means interface 

本课就在domain里定义auth的api接口层，不涉及具体后台的实现
因为接口参数是EmailAddress 和 PassWord，因此bloc收到event必须完成从raw data（String）到 ValueObject的转换