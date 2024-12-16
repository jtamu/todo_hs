-- TODOアプリ
-- - 使い方: ./Main [ファイル名] [オプション]
-- - 指定されたCSVファイルを読み取る（なければ作成）
-- - オプション
--  - add: タスクを追加
--  - list: 全てのタスクを表示
--  - complete [インデックス]: 指定されたインデックスのタスクを完了にする
--  - delete [インデックス]: 指定されたインデックスのタスクを削除する
-- - 例: ./Main tasks.csv add "買い物に行く"
-- - ステータス: yet(未完了), done(完了)

module Main where

import Data.List.Split
import Data.Maybe
import System.IO

main :: IO ()
main = do
  withFile "tasks.csv" ReadMode $ \handle -> do
    contents <- hGetContents handle
    putStrLn "contents: "
    let zipped = zip [1 ..] (tail $ lines contents) :: [(Integer, String)]
        contents' = mapMaybe formatLine zipped

    mapM_ putStrLn contents'

formatLine :: (Integer, String) -> Maybe String
formatLine (i, line) = case splitOn "," line of
  [a, b] -> Just $ show i ++ ") " ++ "task: " ++ a ++ ", status: " ++ b
  _ -> Nothing
