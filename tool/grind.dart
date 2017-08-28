import 'package:grinder/grinder.dart';

void main(List<String> args) => grind(args);

@Task()
void test() => new TestRunner().testAsync();

@DefaultTask()
@Depends(test)
void build() {
  Pub.build();
}

@Task()
void clean() => defaultClean();
