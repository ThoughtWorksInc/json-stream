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

import jsonStream.JsonDeserializer;
import haxe.macro.ExprTools;
import haxe.macro.MacroStringTools;
#if macro
using Lambda;
import haxe.macro.TypeTools;
import haxe.macro.Expr;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
#end

/**
  支持静态类型的反序列化插件。

  本插件会把所有反序列化操作转发到通过`JsonDeserializer.generateDeserializer`创建的类上。

  由于本插件匹配一切类型，所以比本插件先`using`的插件都会失效。通常应当在`using`其他插件以前`using`本插件。
**/
@:final
class GeneratedDeserializerPlugin
{

  @:noDynamicDeserialize
  macro public static function pluginDeserialize<T>(self:ExprOf<JsonDeserializerPluginStream<T>>):ExprOf<T> return
  {
    switch (Context.follow(Context.typeof(self)))
    {
      case TAbstract(_, [ expectedType ]):
        JsonDeserializerGenerator.generatedDeserialize(expectedType, macro $self.underlying);
      case _:
        throw "Expected JsonDeserializerPluginStream";
    }
  }

}

