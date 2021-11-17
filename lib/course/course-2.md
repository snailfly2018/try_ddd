
## couse 2

### Type-safety evolution
### Either a failure or a value
Either 的 left 是 failure union的对象， right 是正常值对象，所以fpdart and freezed包，用fpdart换了dartz

such union ValueFailure
第一步：freezed构造ValueFailure Union

`flutter pub run build_runner build --delete-conflicting-outputs`
`flutter pub run build_runner watch`

### Abstract ValueObject

所以EmailAddress 和 PassWord 两个类将在工厂构造的时候就明确是left或者right了，验证过程包含在构造中，加强了安全性，和正确错误处理链条的同一性。

. 值对象有一个抽象类定义共同的接口，值对象是个带验证构造工厂的对象，值对象包含正确和错误的结果，left or right
. 值对象的错误类型是freezed的union
. 值对象及错误对象都是immutable