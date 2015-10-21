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

package jsonStream.crossPlatformTypes;
import haxe.Int64;

#if (scala && java)
typedef StmNativeRef<A> = scala.concurrent.stm.Ref<A>;
#elseif cs
typedef StmNativeRef<A> = A;
#else
typedef StmNativeRef<A> = A;
#end

@:nativeGen
abstract StmRef<A>(StmNativeRef<A>)
{
  public var underlying(get, never):StmNativeRef<A>;

  @:extern
  inline function get_underlying():StmNativeRef<A> return
  {
    this;
  }

  public inline function new(underlying:StmNativeRef<A>)
  {
    this = underlying;
  }

  @:from public static inline function makeInt(value:Int):StmRef<Int> return
  {
    #if (scala && java)
      new StmRef(scala.concurrent.stm.Ref.Ref_.MODULE_.apply(value));
    #else
      new StmRef(value);
    #end
  }

  @:from public static inline function makeInt64(value:Int64):StmRef<Int64> return
  {
    #if (scala && java)
      new StmRef(scala.concurrent.stm.Ref.Ref_.MODULE_.apply(value));
    #else
      new StmRef(value);
    #end
  }

  @:from public static inline function makeBool(value:Bool):StmRef<Bool> return
  {
    #if (scala && java)
      new StmRef(scala.concurrent.stm.Ref.Ref_.MODULE_.apply(value));
    #else
      new StmRef(value);
    #end
  }

  @:from public static inline function make<A>(value:A):StmRef<A> return
  {
    #if (scala && java)
      var refView = scala.concurrent.stm.japi.STM.newRef(value);
      new StmRef(refView.ref());
    #else
      new StmRef(value);
    #end
  }

  public static inline function empty<A>():StmRef<A> return
  {
    make((null:A));
  }
}
