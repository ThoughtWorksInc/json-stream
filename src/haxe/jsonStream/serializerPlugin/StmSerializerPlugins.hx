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

package jsonStream.serializerPlugin;


#if (scala && (java || macro))

import com.dongxiguo.continuation.Continuation;
import com.dongxiguo.continuation.utils.Generator;
import jsonStream.JsonSerializer;
import jsonStream.JsonStream;
import haxe.macro.Context;
import haxe.macro.TypeTools;
#if scala
import scala.concurrent.stm.Ref;
import scala.concurrent.stm.TSet;
import scala.concurrent.stm.TMap;
import scala.concurrent.stm.TArray;
#end

@:final
class StmRefSerializerPlugin
{
  #if java
  @:dox(hide)
  @:noUsing
  public static function serializeForElement<Element>(data:JsonSerializerPluginData<scala.concurrent.stm.Ref<Element>>, elementSerializeFunction:JsonSerializerPluginData<Element>->JsonStream):JsonStream return
  {
    if (data == null)
    {
      NULL;
    }
    else
    {
      var i = data.underlying.single().get();
      elementSerializeFunction(new JsonSerializerPluginData(i));
    }
  }
  #end

  #if (java || macro)
  macro public static function pluginSerialize<Element>(self:ExprOf<JsonSerializerPluginData<scala.concurrent.stm.Ref<Element>>>):ExprOf<JsonStream> return
  {
    macro jsonStream.serializerPlugin.StmSerializerPlugins.StmRefSerializerPlugin.serializeForElement($self, function(subdata) return subdata.pluginSerialize());
  }
  #end
}

@:final
class StmTSetSerializerPlugin
{
  #if java
  @:dox(hide)
  @:noUsing
  public static function serializeForElement<Element>(data:JsonSerializerPluginData<scala.concurrent.stm.TSet<Element>>, elementSerializeFunction:JsonSerializerPluginData<Element>->JsonStream):JsonStream return
  {
    if (data == null)
    {
      NULL;
    }
    else
    {
      ARRAY(new Generator(Continuation.cpsFunction(function(yield:YieldFunction<JsonStream>):Void
      {
        var iterator = data.underlying.single().iterator();
        while (iterator.hasNext())
        {
          @await yield(elementSerializeFunction(new JsonSerializerPluginData(iterator.next())));
        }
      })));
    }
  }
  #end

  #if (java || macro)
  macro public static function pluginSerialize<Element>(self:ExprOf<JsonSerializerPluginData<scala.concurrent.stm.TSet<Element>>>):ExprOf<JsonStream> return
  {
    macro jsonStream.serializerPlugin.StmSerializerPlugins.StmTSetSerializerPlugin.serializeForElement($self, function(subdata) return subdata.pluginSerialize());
  }
  #end
}

@:final
class StmTArraySerializerPlugin
{
  #if java
  @:dox(hide)
  @:noUsing
  public static function serializeForElement<Element>(data:JsonSerializerPluginData<scala.concurrent.stm.TArray<Element>>, elementSerializeFunction:JsonSerializerPluginData<Element>->JsonStream):JsonStream return
  {
    if (data == null)
    {
      NULL;
    }
    else
    {
      ARRAY(new Generator(Continuation.cpsFunction(function(yield:YieldFunction<JsonStream>):Void
      {
        var iterator = data.underlying.single().iterator();
        while (iterator.hasNext())
        {
          @await yield(elementSerializeFunction(new JsonSerializerPluginData(iterator.next())));
        }
      })));
    }
  }
  #end

  #if (java || macro)
  macro public static function pluginSerialize<Element>(self:ExprOf<JsonSerializerPluginData<scala.concurrent.stm.TArray<Element>>>):ExprOf<JsonStream> return
  {
    macro jsonStream.serializerPlugin.StmSerializerPlugins.StmTArraySerializerPlugin.serializeForElement($self, function(subdata) return subdata.pluginSerialize());
  }
  #end
}

class StmTMapSerializerPlugin
{
  #if java
  @:dox(hide)
  @:noUsing
  public static function serializeForElement<Key, Value>(
    data:JsonSerializerPluginData<scala.concurrent.stm.TMap<Key, Value>>,
    keySerializeFunction:JsonSerializerPluginData<Key>->JsonStream,
    valueSerializeFunction:JsonSerializerPluginData<Value>->JsonStream):JsonStream return
  {
    if (data == null)
    {
      NULL;
    }
    else
    {
      ARRAY(new Generator(Continuation.cpsFunction(function(yield:YieldFunction<JsonStream>):Void
      {
        var iterator = data.underlying.single().iterator();
        while (iterator.hasNext())
        {
          @await yield(ARRAY(
          new Generator(Continuation.cpsFunction(function(yield:YieldFunction<JsonStream>):Void
          {
            var element = iterator.next();
            @await yield(keySerializeFunction(new JsonSerializerPluginData(element._1)));
            @await yield(valueSerializeFunction(new JsonSerializerPluginData(element._2)));
          }))));
        }
      })));
    }
  }
  #end

  #if (java || macro)
  macro public static function pluginSerialize<Key, Value>(self:ExprOf<JsonSerializerPluginData<scala.concurrent.stm.TMap<Key, Value>>>):ExprOf<JsonStream> return
  {
    macro jsonStream.serializerPlugin.StmSerializerPlugins.StmTMapSerializerPlugin.serializeForElement($self, function(subdata1) return subdata1.pluginSerialize(), function(subdata2) return subdata2.pluginSerialize());
  }
  #end
}

#end
