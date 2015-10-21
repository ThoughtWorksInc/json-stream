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
import jsonStream.JsonStream;
import jsonStream.unknown.UnknownType;
#if macro
import haxe.macro.TypeTools;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
#end

/**
  支持生成`Dynamic`类型的反序列化插件。
**/
class LowPriorityDynamicDeserializerPlugin
{

  @:noDynamicDeserialize
  macro public static function pluginDeserialize(
    self:ExprOf<JsonDeserializerPluginStream<LowPriorityDynamic>>)
    :ExprOf<Null<Dynamic>> return
  {
    switch (Context.follow(Context.typeof(self)))
    {
      case TAbstract(_, [ expectedType ]):
        JsonDeserializerGenerator.dynamicDeserialize(
          macro $self.underlying,
          expectedType);
      case _:
        throw "Expected JsonDeserializerPluginStream";
    }
  }

}

