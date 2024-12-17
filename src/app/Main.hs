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

import Data.List
import Data.List.Split
import Data.Maybe
import System.Directory
import System.Environment
import System.IO

main :: IO ()
main = do
  args <- getArgs
  case args of
    fileName : command : rest -> switchCommand fileName command rest
    _ -> putStrLn "Usage: ./Main [ファイル名] [オプション]"

tmpFileName :: String
tmpFileName = "tmp.csv"

switchCommand :: String -> String -> [String] -> IO ()
switchCommand fileName "list" _ = listTasks fileName
switchCommand fileName "add" [task] = addTask fileName task
switchCommand fileName "delete" [index] = deleteTask fileName (read index :: Integer)
switchCommand fileName "complete" [index] = completeTask fileName (read index :: Integer)
switchCommand _ _ _ = putStrLn "Unknown command"

addTask :: String -> String -> IO ()
addTask fileName task = do
  let contents = task ++ ",yet\n"
  putStrLn $ "write content: " ++ contents
  appendFile fileName contents

deleteTask :: String -> Integer -> IO ()
deleteTask fileName index = do
  withFile fileName ReadMode $ \handle -> do
    contents <- hGetContents handle
    let lines_ = lines contents
        newLines = [x | (idx, x) <- zip [0 ..] lines_, idx /= index]

    withFile tmpFileName WriteMode $ \tmpHandle -> do
      mapM_ (hPutStrLn tmpHandle) newLines

  renameFile tmpFileName fileName
  putStrLn $ "deleted:" ++ show index

completeTask :: String -> Integer -> IO ()
completeTask fileName index = do
  withFile fileName ReadMode $ \handle -> do
    contents <- hGetContents handle
    let lines_ = lines contents
        newLines = [if idx /= index then x else replaceAll "yet" "done" x | (idx, x) <- zip [0 ..] lines_]

    withFile tmpFileName WriteMode $ \tmpHandle -> do
      mapM_ (hPutStrLn tmpHandle) newLines

  renameFile tmpFileName fileName
  putStrLn $ "completed:" ++ show index

replaceAll :: String -> String -> String -> String
replaceAll old new = intercalate new . splitOn old

listTasks :: String -> IO ()
listTasks fileName = do
  withFile fileName ReadMode $ \handle -> do
    contents <- hGetContents handle
    putStrLn "contents: "
    mapM_ putStrLn (formatTasks contents)

formatTasks :: String -> [String]
formatTasks contents = mapMaybe formatTask (zip [1 ..] (tail $ lines contents))

formatTask :: (Integer, String) -> Maybe String
formatTask (i, line) = case splitOn "," line of
  [a, b] -> Just $ show i ++ ") " ++ "task: " ++ a ++ ", status: " ++ b
  _ -> Nothing
