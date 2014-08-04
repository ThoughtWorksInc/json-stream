package com.qifun.jsonStream.serializerPlugin;


#if (scala && (java || macro))

import com.dongxiguo.continuation.Continuation;
import com.dongxiguo.continuation.utils.Generator;
import com.qifun.jsonStream.JsonSerializer;
import com.qifun.jsonStream.JsonStream;
import haxe.macro.Context;
import haxe.macro.TypeTools;
import scala.collection.immutable.Seq;
import scala.collection.immutable.Set;
import scala.collection.immutable.Map;

/**
  ```scala.collection.immutable.Seq```的序列化插件。
**/
@:final
class SeqScalaSerializerPlugin
{
  #if java
  public static function serializeForElement<Element>(self:JsonSerializerPluginData<scala.collection.immutable.Seq<Element>>, elementSerializeFunction:JsonSerializerPluginData<Element>->JsonStream):JsonStream return
  {
    if (self.underlying == null)
    {
      NULL;
    }
    else
    {
      ARRAY(new Generator(Continuation.cpsFunction(function(yield:YieldFunction<JsonStream>):Void
      {
        var iterator = self.underlying.iterator();
        while (iterator.hasNext())
        {
          yield(elementSerializeFunction(new JsonSerializerPluginData(iterator.next()))).async();
        }
      })));
    }
  }
  #end

  #if (java || macro)
  macro public static function pluginSerialize<Element>(self:ExprOf<JsonSerializerPluginData<scala.collection.immutable.Seq<Element>>>):ExprOf<JsonStream> return
  {
    macro com.qifun.jsonStream.serializerPlugin.ScalaTypeSerializerPlugins.SeqScalaSerializerPlugin.serializeForElement($self, function(subdata) return subdata.pluginSerialize());
  }
  #end
}


/**
  ```scala.collection.immutable.Seq```的序列化插件。
**/
@:final
class SetScalaSerializerPlugin
{
  #if java
  public static function serializeForElement<Element>(self:JsonSerializerPluginData<scala.collection.immutable.Set<Element>>, elementSerializeFunction:JsonSerializerPluginData<Element>->JsonStream):JsonStream return
  {
    if (self.underlying == null)
    {
      NULL;
    }
    else
    {
      ARRAY(new Generator(Continuation.cpsFunction(function(yield:YieldFunction<JsonStream>):Void
      {
        var iterator = self.underlying.iterator();
        while (iterator.hasNext())
        {
          yield(elementSerializeFunction(new JsonSerializerPluginData(iterator.next()))).async();
        }
      })));
    }
  }
  #end

  #if (java || macro)
  macro public static function pluginSerialize<Element>(self:ExprOf<JsonSerializerPluginData<scala.collection.immutable.Set<Element>>>):ExprOf<JsonStream> return
  {
    macro com.qifun.jsonStream.serializerPlugin.ScalaTypeSerializerPlugins.SetScalaSerializerPlugin.serializeForElement($self, function(subdata) return subdata.pluginSerialize());
  }
  #end
}



/**
  ```scala.collection.immutable.Map```的序列化插件。
**/
@:final
class MapScalaSerializerPlugin
{
  #if java
  public static function serializeForElement<Key, Value>(
    self:JsonSerializerPluginData<scala.collection.immutable.Map<Key, Value>>, 
    KeySerializeFunction:JsonSerializerPluginData<Key>->JsonStream, 
    ValueSerializeFunction:JsonSerializerPluginData<Value>->JsonStream):JsonStream return
  {
    if (self.underlying == null)
    {
      NULL;
    }
    else
    {
      ARRAY(new Generator(Continuation.cpsFunction(function(yield:YieldFunction<JsonStream>):Void
      {
        var iterator = self.underlying.iterator();
        while (iterator.hasNext())
        {
          yield(ARRAY(
          new Generator(Continuation.cpsFunction(function(yield:YieldFunction<JsonStream>):Void
          {
            var element = iterator.next();
            yield(KeySerializeFunction(new JsonSerializerPluginData(element._1))).async();
            yield(ValueSerializeFunction(new JsonSerializerPluginData(element._2))).async();
          })))).async();
        }
      })));
    }
  }
  #end

  #if (java || macro)
  macro public static function pluginSerialize<Key, Value>(self:ExprOf<JsonSerializerPluginData<scala.collection.immutable.Map<Key, Value>>>):ExprOf<JsonStream> return
  {
    macro com.qifun.jsonStream.serializerPlugin.ScalaTypeSerializerPlugins.MapScalaSerializerPlugin.serializeForElement($self, function(subdata1) return subdata1.pluginSerialize(), function(subdata2) return subdata2.pluginSerialize());
  }
  #end
}
#end
