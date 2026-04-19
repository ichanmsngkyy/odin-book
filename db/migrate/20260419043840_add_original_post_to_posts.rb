class AddOriginalPostToPosts < ActiveRecord::Migration[8.1]
  def change
    add_reference :posts, :original_post, null: true, foreign_key: { to_table: :posts }
    add_index :posts, [ :user_id, :original_post_id ], unique: true, where: "original_post_id IS NOT NULL", name: "index_posts_on_user_and_original_post"
  end
end
