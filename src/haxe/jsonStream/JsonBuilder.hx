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
import haxe.crypto.Base64;
import haxe.macro.Expr;
import jsonStream.JsonStream;
import haxe.Int64;

abstract JsonObjectBuilder(Null<String>->Null<AsynchronousJsonStream>->Void) from (Null<String>->Null<AsynchronousJsonStream>->Void)
{

  public inline function end():Void
  {
    this(null, null);
  }

  public inline function addTrue(key:String):Void
  {
    this(key, TRUE);
  }

  public inline function addFalse(key:String):Void
  {
    this(key, FALSE);
  }

  public inline function addNull(key:String):Void
  {
    this(key, NULL);
  }

  public inline function addNumber(key:String, value:Float):Void
  {
    this(key, NUMBER(value));
  }

  public inline function addString(key:String, value:String):Void
  {
    this(key, STRING(value));
  }

  public inline function addObject(key:String):JsonObjectBuilder return
  {
    var result:Null<JsonObjectBuilder> = null;
    this(key, OBJECT(function(job) return result = job));
    result;
  }

  public inline function addArray(key:String):JsonArrayBuilder return
  {
    var result:Null<JsonArrayBuilder> = null;
    this(key, ARRAY(function(jab) return result = jab));
    result;
  }

  public inline function addStream(key:String, value:JsonStream):Void
  {
    this(key, JsonStreamToAsynchronous.jsonStreamToAsynchronous(value));
  }

}

abstract JsonArrayBuilder(Null<AsynchronousJsonStream>->Void) from (Null<AsynchronousJsonStream>->Void)
{
  public inline function end():Void
  {
    this(null);
  }

  public inline function addTrue():Void
  {
    this(TRUE);
  }

  public inline function addFalse():Void
  {
    this(FALSE);
  }

  public inline function addNull():Void
  {
    this(NULL);
  }

  public inline function addNumber(value:Float):Void
  {
    this(NUMBER(value));
  }

  public inline function addString(value:String):Void
  {
    this(STRING(value));
  }

  public inline function addObject():JsonObjectBuilder return
  {
    var result:Null<JsonObjectBuilder> = null;
    this(OBJECT(function(job) return result = job));
    result;
  }

  public inline function addArray():JsonArrayBuilder return
  {
    var result:Null<JsonArrayBuilder> = null;
    this(ARRAY(function(jab) return result = jab));
    result;
  }

  public inline function addStream(value:JsonStream):Void
  {
    this(JsonStreamToAsynchronous.jsonStreamToAsynchronous(value));
  }
}

/**
  输入Json数据，生成`Result`的构造器。
**/
class JsonBuilder<Result>
{

  var asynchronousFunction:AsynchronousJsonStream->(Result->Void)->Void;

  public var result(default, null):Result;

  public inline function new(asynchronousFunction:AsynchronousJsonStream->(Result->Void)->Void)
  {
    this.asynchronousFunction = asynchronousFunction;
  }

  private function newSetter() return function(r):Void
  {
    result = r;
  }

  public inline function setTrue():Void
  {
    asynchronousFunction(TRUE, newSetter());
  }

  public inline function setFalse():Void
  {
    asynchronousFunction(FALSE, newSetter());
  }

  public inline function setNull():Void
  {
    asynchronousFunction(NULL, newSetter());
  }

  public inline function setNumber(value:Float):Void
  {
    asynchronousFunction(NUMBER(value), newSetter());
  }

  public inline function setString(value:String):Void
  {
    asynchronousFunction(STRING(value), newSetter());
  }

  public inline function setObject():JsonObjectBuilder return
  {
    var b:JsonObjectBuilder;
    asynchronousFunction(
      OBJECT(
        function(builder):Void
        {
          b = builder;
        }),
      newSetter());
    b;
  }

  public inline function setArray():JsonArrayBuilder return
  {
    var b:JsonArrayBuilder;
    asynchronousFunction(
      ARRAY(
        function(builder):Void
        {
          b = builder;
        }),
      newSetter());
    b;
  }

  public inline function setStream(value:JsonStream):Void
  {
    asynchronousFunction(
      JsonStreamToAsynchronous.jsonStreamToAsynchronous(value), newSetter());
  }

}

/**
  生成所需的`JsonBuilder`异步流，
  仅供`JsonBuilder`插件和`JsonBuilderFactory`项目内部实现使用
**/
@:dox(hide)
enum AsynchronousJsonStream
{
  TRUE;
  FALSE;
  NULL;
  STRING(value:String);
  NUMBER(value:Float);
  OBJECT(read:(Null<String>->Null<AsynchronousJsonStream>->Void)->Void);
  ARRAY(read:(Null<AsynchronousJsonStream>->Void)->Void);
}

private class JsonStreamToAsynchronous
{

  macro static function newReadArrayFunction(elements:Expr) return
  {
    macro function(handler):Void
    {
      if ($elements.hasNext())
      {
        handler(jsonStreamToAsynchronous($elements.next()));
      }
      else
      {
        handler(null);
      }
    }
  }

  macro static function newReadObjectFunction(pairs:Expr) return
  {
    macro function(handler):Void
    {
      if ($pairs.hasNext())
      {
        var pair = $pairs.next();
        handler(pair.key, jsonStreamToAsynchronous(pair.value));
      }
      else
      {
        handler(null, null);
      }
    }
  }

  @:noUsing
  public static function jsonStreamToAsynchronous(stream:JsonStream):AsynchronousJsonStream return
  {
    switch (stream)
    {
      case STRING(value):
        STRING(value);
      case NUMBER(value):
        NUMBER(value);
      case TRUE:
        TRUE;
      case FALSE:
        FALSE;
      case NULL:
        NULL;
      case OBJECT(pairs):
        var generator =
          Std.instance(pairs, (Generator:Class<Generator<JsonStreamPair>>));
        if (generator != null)
        {
          OBJECT(newReadObjectFunction(generator));
        }
        else
        {
          OBJECT(newReadObjectFunction(pairs));
        }
      case ARRAY(elements):
        var generator =
          Std.instance(elements, (Generator:Class<Generator<JsonStream>>));
        if (generator != null)
        {
          ARRAY(newReadArrayFunction(generator));
        }
        else
        {
          ARRAY(newReadArrayFunction(elements));
        }
      case INT32(value):
      {
        NUMBER(value);
      }
      case INT64(high, low):
      {
        ARRAY(newReadArrayFunction(new Generator(Continuation.cpsFunction(function(yield:YieldFunction<JsonStream>):Void
        {
          @await yield(NUMBER(high));
          @await yield(NUMBER(low));
        }))));
      }
      case BINARY(value):
      {
        STRING(Base64.encode(value));
      }
    }
  }
}
