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
import System.Environment
import System.IO

main :: IO ()
main = do
  args <- getArgs
  case args of
    [fileName, command] -> switchCommand fileName command
    _ -> putStrLn "Usage: ./Main [ファイル名] [オプション]"

switchCommand :: String -> String -> IO ()
switchCommand fileName "list" = listContents fileName
switchCommand _ _ = putStrLn "Unknown command"

listContents :: String -> IO ()
listContents fileName = do
  withFile fileName ReadMode $ \handle -> do
    contents <- hGetContents handle
    putStrLn "contents: "
    mapM_ putStrLn (formatContents contents)

formatContents :: String -> [String]
formatContents contents = mapMaybe formatLine (zip [1 ..] (tail $ lines contents))

formatLine :: (Integer, String) -> Maybe String
formatLine (i, line) = case splitOn "," line of
  [a, b] -> Just $ show i ++ ") " ++ "task: " ++ a ++ ", status: " ++ b
  _ -> Nothing
