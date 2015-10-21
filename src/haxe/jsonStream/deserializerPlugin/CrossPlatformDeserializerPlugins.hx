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

package jsonStream.deserializerPlugin;


import haxe.ds.Vector;
import haxe.macro.*;
import haxe.macro.Expr;
import jsonStream.JsonStream;
import jsonStream.JsonDeserializer;

@:final
class CrossPlatformRefDeserializerPlugin
{
  @:noUsing
  @:dox(hide)
  public static inline function toNativeStream<Element>(stream:JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.CrossRef<Element>>) return
  {
    #if (java && scala && scala_stm)
      new JsonDeserializerPluginStream<scala.concurrent.stm.Ref<Element>>(stream.underlying);
    #else
      new JsonDeserializerPluginStream<Element>(stream.underlying);
    #end
  }


  @:noDynamicDeserialize
  macro public static function pluginDeserialize<Element>(self:ExprOf<JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.CrossRef<Element>>>):ExprOf<Null<jsonStream.crossPlatformTypes.CrossRef<Element>>> return
  {
    if (Context.defined("java") && Context.defined("scala") && Context.defined("scala_stm"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.CrossPlatformRefDeserializerPlugin.toNativeStream($self);
        var nativeResult = jsonStream.deserializerPlugin.StmDeserializerPlugins.StmRefDeserializerPlugin.deserializeForElement(nativeStream, function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.CrossRef(nativeResult);
      }
    }
    else
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.CrossPlatformRefDeserializerPlugin.toNativeStream($self);
        var nativeResult = nativeStream.pluginDeserialize();
        new jsonStream.crossPlatformTypes.CrossRef(nativeResult);
      }
    }
  }
}


@:final
class StmTRefDeserializerPlugin
{
  @:noUsing
  @:dox(hide)
  public static inline function toNativeStream<Value>(stream:JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.StmRef<Value>>) return
  {
    new JsonDeserializerPluginStream<Value>(stream.underlying);
  }


  @:noDynamicDeserialize
  macro public static function pluginDeserialize<Value>(self:ExprOf<JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.StmRef<Value>>>):ExprOf<Null<jsonStream.crossPlatformTypes.StmRef<Value>>> return
  {
    macro
    {
      var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.StmTRefDeserializerPlugin.toNativeStream($self);
      var nativeResult = nativeStream.pluginDeserialize();
      jsonStream.crossPlatformTypes.StmRef.make(nativeResult);
    }
  }
}


@:final
class CrossPlatformSetDeserializerPlugin
{
  @:noUsing
  @:dox(hide)
  public static inline function toNativeStream<Element>(stream:JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.CrossSet<Element>>) return
  {
    #if (java && scala)
      #if scala_stm
        new JsonDeserializerPluginStream<scala.concurrent.stm.TSet<Element>>(stream.underlying);
      #else
        new JsonDeserializerPluginStream<scala.collection.immutable.Set<Element>>(stream.underlying);
      #end
    #elseif cs
      new JsonDeserializerPluginStream<dotnet.system.collections.generic.HashSet<Element>>(stream.underlying);
    #end
  }

  @:noDynamicDeserialize
  macro public static function pluginDeserialize<Element>(self:ExprOf<JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.CrossSet<Element>>>):ExprOf<Null<jsonStream.crossPlatformTypes.CrossSet<Element>>> return
  {
    if (Context.defined("java") && Context.defined("scala"))
    {
      if (Context.defined("scala_stm"))
      {
        macro
        {
          var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.CrossPlatformSetDeserializerPlugin.toNativeStream($self);
          var nativeResult =
            jsonStream.deserializerPlugin.StmDeserializerPlugins.StmTSetDeserializerPlugin.deserializeForElement(
              nativeStream,
              function(substream) return substream.pluginDeserialize());
          new jsonStream.crossPlatformTypes.CrossSet(nativeResult);
        }
      }
      else
      {
        macro
        {
          var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.CrossPlatformSetDeserializerPlugin.toNativeStream($self);
          var nativeResult =
            jsonStream.deserializerPlugin.ScalaDeserializerPlugins.ScalaSetDeserializerPlugin.deserializeForElement(
              nativeStream,
              function(substream) return substream.pluginDeserialize());
          new jsonStream.crossPlatformTypes.CrossSet(nativeResult);
        }
      }
    }
    else if (Context.defined("cs"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.CrossPlatformSetDeserializerPlugin.toNativeStream($self);
        var nativeResult =
          jsonStream.deserializerPlugin.CSharpDeserializerPlugins.CSharpHashSetDeserializerPlugin.deserializeForElement(
            nativeStream,
            function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.CrossSet(nativeResult);
      }
    }
    else
    {
      Context.error("Unsupported platform", Context.currentPos());
    }
  }

}


@:final
class StmSetDeserializerPlugin
{
  @:noUsing
  @:dox(hide)
  public static inline function toNativeStream<Element>(stream:JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.StmSet<Element>>) return
  {
    #if (java && scala)
      new JsonDeserializerPluginStream<scala.concurrent.stm.TSet<Element>>(stream.underlying);
    #elseif cs
      new JsonDeserializerPluginStream<dotnet.system.collections.generic.HashSet<Element>>(stream.underlying);
    #end
  }

  @:noDynamicDeserialize
  macro public static function pluginDeserialize<Element>(self:ExprOf<JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.StmSet<Element>>>):ExprOf<Null<jsonStream.crossPlatformTypes.StmSet<Element>>> return
  {
    if (Context.defined("java") && Context.defined("scala"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.StmSetDeserializerPlugin.toNativeStream($self);
        var nativeResult =
          jsonStream.deserializerPlugin.StmDeserializerPlugins.StmTSetDeserializerPlugin.deserializeForElement(
            nativeStream,
            function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.StmSet(nativeResult);
      }
    }
    else if (Context.defined("cs"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.StmSetDeserializerPlugin.toNativeStream($self);
        var nativeResult =
          jsonStream.deserializerPlugin.CSharpDeserializerPlugins.CSharpHashSetDeserializerPlugin.deserializeForElement(
            nativeStream,
            function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.StmSet(nativeResult);
      }
    }
    else
    {
      Context.error("Unsupported platform", Context.currentPos());
    }
  }

}


@:final
class ImmutableSetDeserializerPlugin
{
  @:noUsing
  @:dox(hide)
  public static inline function toNativeStream<Element>(stream:JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.ImmutableSet<Element>>) return
  {
    #if (java && scala)
      new JsonDeserializerPluginStream<scala.collection.immutable.Set<Element>>(stream.underlying);
    #elseif cs
      new JsonDeserializerPluginStream<dotnet.system.collections.generic.HashSet<Element>>(stream.underlying);
    #end
  }

  @:noDynamicDeserialize
  macro public static function pluginDeserialize<Element>(self:ExprOf<JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.ImmutableSet<Element>>>):ExprOf<Null<jsonStream.crossPlatformTypes.ImmutableSet<Element>>> return
  {
    if (Context.defined("java") && Context.defined("scala"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.ImmutableSetDeserializerPlugin.toNativeStream($self);
        var nativeResult =
          jsonStream.deserializerPlugin.ScalaDeserializerPlugins.ScalaSetDeserializerPlugin.deserializeForElement(
            nativeStream,
            function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.ImmutableSet(nativeResult);
      }
    }
    else if (Context.defined("cs"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.ImmutableSetDeserializerPlugin.toNativeStream($self);
        var nativeResult =
          jsonStream.deserializerPlugin.CSharpDeserializerPlugins.CSharpHashSetDeserializerPlugin.deserializeForElement(
            nativeStream,
            function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.ImmutableSet(nativeResult);
      }
    }
    else
    {
      Context.error("Unsupported platform", Context.currentPos());
    }
  }

}

@:final
class CrossPlatformMapDeserializerPlugin
{
  @:noUsing
  @:dox(hide)
  public static inline function toNativeStream<Key, Value>(stream:JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.CrossMap<Key, Value>>) return
  {
    #if (java && scala)
      #if scala_stm
        new JsonDeserializerPluginStream<scala.concurrent.stm.TMap<Key, Value>>(stream.underlying);
      #else
        new JsonDeserializerPluginStream<scala.collection.immutable.Map<Key, Value>>(stream.underlying);
      #end
    #elseif cs
      new JsonDeserializerPluginStream<dotnet.system.collections.generic.Dictionary<Key, Value>>(stream.underlying);
    #end
  }

  @:noDynamicDeserialize
  macro public static function pluginDeserialize<Key, Value>(self:ExprOf<JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.CrossMap<Key, Value>>>):ExprOf<Null<jsonStream.crossPlatformTypes.CrossMap<Key, Value>>> return
  {
    if (Context.defined("java") && Context.defined("scala"))
    {
      if (Context.defined("scala_stm"))
      {
        macro
        {
          var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.CrossPlatformMapDeserializerPlugin.toNativeStream($self);
          var nativeResult = jsonStream.deserializerPlugin.StmDeserializerPlugins.StmTMapDeserializerPlugin.deserializeForElement(nativeStream, function(substream) return substream.pluginDeserialize(), function(substream) return substream.pluginDeserialize());
          new jsonStream.crossPlatformTypes.CrossMap(nativeResult);
        }
      }
      else
      {
        macro
        {
          var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.CrossPlatformMapDeserializerPlugin.toNativeStream($self);
          var nativeResult = jsonStream.deserializerPlugin.ScalaDeserializerPlugins.ScalaMapDeserializerPlugin.deserializeForElement(nativeStream, function(substream) return substream.pluginDeserialize(), function(substream) return substream.pluginDeserialize());
          new jsonStream.crossPlatformTypes.CrossMap(nativeResult);
        }
      }
    }
    else if (Context.defined("cs"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.CrossPlatformMapDeserializerPlugin.toNativeStream($self);
        var nativeResult = jsonStream.deserializerPlugin.CSharpDeserializerPlugins.CSharpDictionaryDeserializerPlugin.deserializeForElement(nativeStream, function(substream) return substream.pluginDeserialize(), function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.CrossMap(nativeResult);
      }
    }
    else
    {
      Context.error("Unsupported platform", Context.currentPos());
    }
  }
}


@:final
class StmMapDeserializerPlugin
{
  @:noUsing
  @:dox(hide)
  public static inline function toNativeStream<Key, Value>(stream:JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.StmMap<Key, Value>>) return
  {
    #if (java && scala)
      new JsonDeserializerPluginStream<scala.concurrent.stm.TMap<Key, Value>>(stream.underlying);
    #elseif cs
      new JsonDeserializerPluginStream<dotnet.system.collections.generic.Dictionary<Key, Value>>(stream.underlying);
    #end
  }

  @:noDynamicDeserialize
  macro public static function pluginDeserialize<Key, Value>(self:ExprOf<JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.StmMap<Key, Value>>>):ExprOf<Null<jsonStream.crossPlatformTypes.StmMap<Key, Value>>> return
  {
    if (Context.defined("java") && Context.defined("scala"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.StmMapDeserializerPlugin.toNativeStream($self);
        var nativeResult = jsonStream.deserializerPlugin.StmDeserializerPlugins.StmTMapDeserializerPlugin.deserializeForElement(nativeStream, function(substream) return substream.pluginDeserialize(), function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.StmMap(nativeResult);
      }
    }
    else if (Context.defined("cs"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.StmMapDeserializerPlugin.toNativeStream($self);
        var nativeResult = jsonStream.deserializerPlugin.CSharpDeserializerPlugins.CSharpDictionaryDeserializerPlugin.deserializeForElement(nativeStream, function(substream) return substream.pluginDeserialize(), function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.StmMap(nativeResult);
      }
    }
    else
    {
      Context.error("Unsupported platform", Context.currentPos());
    }
  }
}


@:final
class ImmutableMapDeserializerPlugin
{
  @:noUsing
  @:dox(hide)
  public static inline function toNativeStream<Key, Value>(stream:JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.ImmutableMap<Key, Value>>) return
  {
    #if (java && scala)
      new JsonDeserializerPluginStream<scala.collection.immutable.Map<Key, Value>>(stream.underlying);
    #elseif cs
      new JsonDeserializerPluginStream<dotnet.system.collections.generic.Dictionary<Key, Value>>(stream.underlying);
    #end
  }

  @:noDynamicDeserialize
  macro public static function pluginDeserialize<Key, Value>(self:ExprOf<JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.ImmutableMap<Key, Value>>>):ExprOf<Null<jsonStream.crossPlatformTypes.ImmutableMap<Key, Value>>> return
  {
    if (Context.defined("java") && Context.defined("scala"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.ImmutableMapDeserializerPlugin.toNativeStream($self);
        var nativeResult = jsonStream.deserializerPlugin.ScalaDeserializerPlugins.ScalaMapDeserializerPlugin.deserializeForElement(nativeStream, function(substream) return substream.pluginDeserialize(), function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.ImmutableMap(nativeResult);
      }
    }
    else if (Context.defined("cs"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.ImmutableMapDeserializerPlugin.toNativeStream($self);
        var nativeResult = jsonStream.deserializerPlugin.CSharpDeserializerPlugins.CSharpDictionaryDeserializerPlugin.deserializeForElement(nativeStream, function(substream) return substream.pluginDeserialize(), function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.ImmutableMap(nativeResult);
      }
    }
    else
    {
      Context.error("Unsupported platform", Context.currentPos());
    }
  }
}

@:final
class CrossPlatformVectorDeserializerPlugin
{
  @:noUsing
  @:dox(hide)
  public static inline function toNativeStream<Element>(stream:JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.CrossVector<Element>>) return
  {
    #if (java && scala && scala_stm)
      new JsonDeserializerPluginStream<scala.concurrent.stm.TArray<Element>>(stream.underlying);
    #else
      new JsonDeserializerPluginStream<haxe.ds.Vector<Element>>(stream.underlying);
    #end
  }

  @:noDynamicDeserialize
  macro public static function pluginDeserialize<Element>(self:ExprOf<JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.CrossVector<Element>>>):ExprOf<Null<jsonStream.crossPlatformTypes.CrossVector<Element>>> return
  {
    if (Context.defined("java") && Context.defined("scala") && Context.defined("scala_stm"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.CrossPlatformVectorDeserializerPlugin.toNativeStream($self);
        var nativeResult = jsonStream.deserializerPlugin.StmDeserializerPlugins.StmTArrayDeserializerPlugin.deserializeForElement(nativeStream, function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.CrossVector(nativeResult);
      }
    }
    else
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.CrossPlatformVectorDeserializerPlugin.toNativeStream($self);
        var nativeResult = jsonStream.deserializerPlugin.PrimitiveDeserializerPlugins.VectorDeserializerPlugin.deserializeForElement(nativeStream, function (a) return jsonStream.deserializerPlugin.PrimitiveDeserializerPlugins.VectorDeserializerPlugin.arrayToVector(a), function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.CrossVector(nativeResult);
      }
    }
  }

}


@:final
class StmVectorDeserializerPlugin
{
  @:noUsing
  @:dox(hide)
  public static inline function toNativeStream<Element>(stream:JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.StmVector<Element>>) return
  {
    #if (java && scala)
      new JsonDeserializerPluginStream<scala.concurrent.stm.TArray<Element>>(stream.underlying);
    #else
      new JsonDeserializerPluginStream<haxe.ds.Vector<Element>>(stream.underlying);
    #end
  }

  @:noDynamicDeserialize
  macro public static function pluginDeserialize<Element>(self:ExprOf<JsonDeserializerPluginStream<jsonStream.crossPlatformTypes.StmVector<Element>>>):ExprOf<Null<jsonStream.crossPlatformTypes.StmVector<Element>>> return
  {
    if (Context.defined("java") && Context.defined("scala"))
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.StmVectorDeserializerPlugin.toNativeStream($self);
        var nativeResult = jsonStream.deserializerPlugin.StmDeserializerPlugins.StmTArrayDeserializerPlugin.deserializeForElement(nativeStream, function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.StmVector(nativeResult);
      }
    }
    else
    {
      macro
      {
        var nativeStream = jsonStream.deserializerPlugin.CrossPlatformDeserializerPlugins.StmVectorDeserializerPlugin.toNativeStream($self);
        var nativeResult = jsonStream.deserializerPlugin.PrimitiveDeserializerPlugins.VectorDeserializerPlugin.deserializeForElement(nativeStream, function (a) return jsonStream.deserializerPlugin.PrimitiveDeserializerPlugins.VectorDeserializerPlugin.arrayToVector(a), function(substream) return substream.pluginDeserialize());
        new jsonStream.crossPlatformTypes.StmVector(nativeResult);
      }
    }
  }

}

// vim: et sts=2 sw=2
