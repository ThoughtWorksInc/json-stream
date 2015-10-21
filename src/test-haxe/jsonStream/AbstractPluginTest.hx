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

import com.dongxiguo.continuation.utils.Generator;
import com.dongxiguo.continuation.Continuation;
using jsonStream.Plugins;
using jsonStream.TestIo;
import jsonStream.JsonSerializer;
import jsonStream.testUtil.JsonTestCase;
import jsonStream.JsonStream;
import jsonStream.JsonDeserializer;

class AbstractPluginTest extends JsonTestCase
{
  function testAbstractTypeSerializerPlugins()
  {
    var o = new AbstractEntities();
    #if (java && scala_stm)
      var refView:scala.concurrent.stm.RefView<Int> = scala.concurrent.stm.japi.STM.MODULE.newRef(5);
      o.ref = new jsonStream.crossPlatformTypes.StmRef(refView.ref());
      var setBuilder:scala.collection.mutable.Builder<Int, scala.concurrent.stm.TSet<Int>> = scala.concurrent.stm.TSet.TSetSingleton.MODULE.newBuilder();
      setBuilder._plus_eq(30);
      setBuilder._plus_eq(82);
      setBuilder._plus_eq(255);
      setBuilder._plus_eq(4099);
      setBuilder._plus_eq(96354);
      o.set = new jsonStream.crossPlatformTypes.CrossSet(setBuilder.result());

      var tarrayView:scala.concurrent.stm.TArrayView<String> = scala.concurrent.stm.japi.STM.MODULE.newTArray(5);
      tarrayView.update(0, 1);
      tarrayView.update(1, 1);
      tarrayView.update(2, 2);
      tarrayView.update(3, 3);
      tarrayView.update(4, 5);

      o.list = new jsonStream.crossPlatformTypes.CrossVector(tarrayView.tarray());

      var mapBuilder:scala.collection.mutable.Builder<scala.Tuple2<Int, Int>, scala.concurrent.stm.TMap<Int, Int>> = scala.concurrent.stm.TMap.TMapSingleton.MODULE.newBuilder();
      mapBuilder._plus_eq(new scala.Tuple2(42, 1764));
      mapBuilder._plus_eq(new scala.Tuple2(14, 169));
      mapBuilder._plus_eq(new scala.Tuple2(25, 625));
      mapBuilder._plus_eq(new scala.Tuple2(256, 65536));
      o.map = new jsonStream.crossPlatformTypes.CrossMap(mapBuilder.result());
    #elseif cs
      o.ref = new jsonStream.crossPlatformTypes.CrossRef(5);
      var set = new dotnet.system.collections.generic.HashSet();
      set.Add(30);
      set.Add(82);
      set.Add(255);
      set.Add(4099);
      set.Add(96354);
      o.set = new jsonStream.crossPlatformTypes.CrossSet(set);
      o.list = new jsonStream.crossPlatformTypes.CrossVector(haxe.ds.Vector.fromArrayCopy(["1", "1", "2", "3", "5"]));

      var map = new dotnet.system.collections.generic.Dictionary();
      map.Add(42, 1764);
      map.Add(14, 169);
      map.Add(25, 625);
      map.Add(256, 65536);
      o.map = new jsonStream.crossPlatformTypes.CrossMap(map);
    #elseif (java && scala && !scala_stm)
      o.ref = new jsonStream.crossPlatformTypes.CrossRef(5);
      var setBuilder:scala.collection.mutable.Builder<Int, Dynamic> = scala.collection.immutable.Set.Set_.MODULE_.newBuilder();
      setBuilder._plus_eq(30);
      setBuilder._plus_eq(82);
      setBuilder._plus_eq(255);
      setBuilder._plus_eq(4099);
      setBuilder._plus_eq(96354);
      o.set = new jsonStream.crossPlatformTypes.CrossSet(setBuilder.result());

      o.list = new jsonStream.crossPlatformTypes.CrossVector(haxe.ds.Vector.fromArrayCopy(["1", "1", "2", "3", "5"]));

      var mapBuilder:scala.collection.mutable.Builder<scala.Tuple2<Int, Int>, Dynamic> = scala.collection.immutable.Map.Map_.MODULE_.newBuilder();
      mapBuilder._plus_eq(new scala.Tuple2(42, 1764));
      mapBuilder._plus_eq(new scala.Tuple2(14, 169));
      mapBuilder._plus_eq(new scala.Tuple2(25, 625));
      mapBuilder._plus_eq(new scala.Tuple2(256, 65536));
      o.map = new jsonStream.crossPlatformTypes.CrossMap(mapBuilder.result());
    #end
    var stream = JsonSerializer.serialize(o);

    assertDeepEquals(["1", "1", "2", "3", "5"], JsonDeserializer.deserializeRaw(stream).underlying.list);
  }

  function testAbstractTypeDeseralizerPlugins()
  {
    var o = new AbstractEntities();
    #if (java && scala_stm)
      var refView:scala.concurrent.stm.RefView<Int> = scala.concurrent.stm.japi.STM.MODULE.newRef(5);
      o.ref = new jsonStream.crossPlatformTypes.StmRef(refView.ref());
      var setBuilder:scala.collection.mutable.Builder<Int, scala.concurrent.stm.TSet<Int>> = scala.concurrent.stm.TSet.TSetSingleton.MODULE.newBuilder();
      setBuilder._plus_eq(30);
      setBuilder._plus_eq(82);
      setBuilder._plus_eq(255);
      setBuilder._plus_eq(4099);
      setBuilder._plus_eq(96354);
      o.set = new jsonStream.crossPlatformTypes.CrossSet(setBuilder.result());

      var tarrayView:scala.concurrent.stm.TArrayView<String> = scala.concurrent.stm.japi.STM.MODULE.newTArray(5);
      tarrayView.update(0, 1);
      tarrayView.update(1, 1);
      tarrayView.update(2, 2);
      tarrayView.update(3, 3);
      tarrayView.update(4, 5);

      o.list = new jsonStream.crossPlatformTypes.CrossVector(tarrayView.tarray());

      var mapBuilder:scala.collection.mutable.Builder<scala.Tuple2<Int, Int>, scala.concurrent.stm.TMap<Int, Int>> = scala.concurrent.stm.TMap.TMapSingleton.MODULE.newBuilder();
      mapBuilder._plus_eq(new scala.Tuple2(42, 1764));
      mapBuilder._plus_eq(new scala.Tuple2(14, 169));
      mapBuilder._plus_eq(new scala.Tuple2(25, 625));
      mapBuilder._plus_eq(new scala.Tuple2(256, 65536));
      o.map = new jsonStream.crossPlatformTypes.CrossMap(mapBuilder.result());
    #elseif cs
      o.ref = new jsonStream.crossPlatformTypes.CrossRef(5);
      var set = new dotnet.system.collections.generic.HashSet();
      set.Add(30);
      set.Add(82);
      set.Add(255);
      set.Add(4099);
      set.Add(96354);
      o.set = new jsonStream.crossPlatformTypes.CrossSet(set);

      o.list = new jsonStream.crossPlatformTypes.CrossVector(haxe.ds.Vector.fromArrayCopy(["1", "1", "2", "3", "5"]));

      var map = new dotnet.system.collections.generic.Dictionary();
      map.Add(42, 1764);
      map.Add(14, 169);
      map.Add(25, 625);
      map.Add(256, 65536);
      o.map = new jsonStream.crossPlatformTypes.CrossMap(map);

     #elseif (java && scala && !scala_stm)
      o.ref = new jsonStream.crossPlatformTypes.CrossRef(5);
      var setBuilder:scala.collection.mutable.Builder<Int, Dynamic> = scala.collection.immutable.Set.Set_.MODULE_.newBuilder();
      setBuilder._plus_eq(30);
      setBuilder._plus_eq(82);
      setBuilder._plus_eq(255);
      setBuilder._plus_eq(4099);
      setBuilder._plus_eq(96354);
      o.set = new jsonStream.crossPlatformTypes.CrossSet(setBuilder.result());

      o.list = new jsonStream.crossPlatformTypes.CrossVector(haxe.ds.Vector.fromArrayCopy(["1", "1", "2", "3", "5"]));

      var mapBuilder:scala.collection.mutable.Builder<scala.Tuple2<Int, Int>, Dynamic> = scala.collection.immutable.Map.Map_.MODULE_.newBuilder();
      mapBuilder._plus_eq(new scala.Tuple2(42, 1764));
      mapBuilder._plus_eq(new scala.Tuple2(14, 169));
      mapBuilder._plus_eq(new scala.Tuple2(25, 625));
      mapBuilder._plus_eq(new scala.Tuple2(256, 65536));
      o.map = new jsonStream.crossPlatformTypes.CrossMap<Int, Int>(mapBuilder.result());
    #end
    var stream = JsonSerializer.serializeRaw(new RawJson({ref: 5,
     list:["1", "1", "2", "3", "5"],
     map:[[14, 169], [25, 625], [42, 1764],
     [256,65536]], set :[30,82,255,4099,96354] }));
    var o2:AbstractEntities = JsonDeserializer.deserialize(stream);
    assertDeepEquals(o, o2);
  }

}
// vim: et sts=2 sw=2
