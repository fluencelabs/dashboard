module Utils.ArrayExtras exposing (..)

{-| Copyright 2020 Fluence Labs Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

-}

import Array exposing (Array, append, empty, filter, foldr, fromList, get, push, toList)
import Utils.MaybeExtras exposing (nonEmpty)


find : (a -> Bool) -> Array a -> Maybe a
find f l =
    l |> filter f |> get 0


contains : (a -> Bool) -> Array a -> Bool
contains f l =
    nonEmpty (find f l)


reverse : Array a -> Array a
reverse ar =
    fromList (List.reverse (toList ar))


flatMaybes : Array (Maybe a) -> Array a
flatMaybes ar =
    ar
        |> foldr
            (\m ->
                \a ->
                    case m of
                        Just el ->
                            append a (fromList [ el ])

                        Nothing ->
                            a
            )
            empty
