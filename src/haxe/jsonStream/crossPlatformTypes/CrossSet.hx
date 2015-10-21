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

#if (scala && java)
#if scala_stm
typedef NativeSet<A> = scala.concurrent.stm.TSet<A>;
#else
typedef NativeSet<A> = scala.collection.immutable.Set<A>;
#end
#elseif cs
typedef NativeSet<A> = dotnet.system.collections.generic.HashSet<A>;
#else
import Map in StdMap;
typedef NativeSet<A> = StdMap<A, Bool>;
#end

abstract CrossSet<A>(NativeSet<A>)
{

  public var underlying(get, never):NativeSet<A>;

  @:extern
  inline function get_underlying():NativeSet<A> return
  {
    this;
  }

  inline public function new(set:NativeSet<A>)
  {
    this = set;
  }
}
