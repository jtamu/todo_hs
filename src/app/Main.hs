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

main :: IO ()
main = putStrLn "Hello, Haskell!"
