package jsonStream;

import haxe.unit.TestCase;
import jsonStream.testUtil.JsonTestCase;
import jsonStream.crossPlatformTypes.StmRef;
import haxe.Int64;

//这是haxe的测试用例，为了不影响持续继承，在haxe彻底修复以前注释掉这个bug
/*
class Int64Test extends JsonTestCase
{


  function testInt64AsRefParameter()
  {
    #if (scala && java)
      var int64Stm:StmRef<Int64> = StmRef.empty();
      assertDeepEquals(Int64.make(0, 0), int64Stm.underlying.single().get());
    #else
      var i64 = Int64.make(5, 5);
      var int64Stm:StmRef<Int64> = new StmRef(i64);
      assertDeepEquals(i64, int64Stm.underlying);
    #end
  }

}*/