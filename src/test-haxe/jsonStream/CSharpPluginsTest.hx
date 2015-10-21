/*
 * json-stream
 * Copyright 2014 深圳岂凡网络有限公司 (Shenzhen QiFun Network Corp., LTD)
 *
 * Author: 杨博 (Yang Bo) <pop.atry@gmail.com>, 张修羽 (Zhang Xiuyu) <zxiuyu@126.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package jsonStream;
import haxe.unit.TestCase;
import jsonStream.JsonSerializer;
import jsonStream.JsonStream;
import jsonStream.JsonDeserializer;
import jsonStream.testUtil.JsonTestCase;
using jsonStream.CSharpIo;
import com.dongxiguo.continuation.utils.Generator;
import com.dongxiguo.continuation.Continuation;
using jsonStream.Plugins;

class CSharpPluginsTest extends JsonTestCase
{
 #if cs
 function testCSPlugins()
  {
    var csTest = new CSharpEntities();
    csTest.list.Add(1);
    csTest.list.Add(2);
    csTest.list.Add(3);
    csTest.hashSet.Add(1);
    csTest.hashSet.Add(2);
    csTest.hashSet.Add(3);
    csTest.dictionary.Add(1, 2);
    csTest.dictionary.Add(2, 3);
    csTest.dictionary.Add(3, 1);
    var stream = JsonSerializer.serialize(csTest);
    var outputBuffer = new haxe.io.BytesOutput();
    var csTest2:CSharpEntities = JsonDeserializer.deserialize(stream);

    var jsonStream2 = JsonStream.OBJECT(
      new Generator(Continuation.cpsFunction(function(yield:YieldFunction<JsonStreamPair>):Void
      {
        var jsonArray123 = JsonSerializer.serialize([1, 2, 3]);
        @await yield(new JsonStreamPair("list", jsonArray123));
        @await yield(new JsonStreamPair("hashSet", jsonArray123));
        @await yield(new JsonStreamPair("dictionary", JsonSerializer.serialize([[1, 2], [2, 3], [3, 1]])));
      }
    )));

    var csTest3:CSharpEntities = JsonDeserializer.deserialize(jsonStream2);

    assertDeepEquals(csTest, csTest2);
    assertDeepEquals(csTest, csTest3);

  }
  #end
}
