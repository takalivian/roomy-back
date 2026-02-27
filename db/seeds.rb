# デモ用データ

5.times do |i|
  company = Company.find_or_create_by!(name: "デモ株式会社#{i + 1}")

  # 管理者ユーザー（各社1人）
  company.users.find_or_create_by!(email: "admin#{i + 1}@example.com") do |u|
    u.name = "管理者 太郎#{i + 1}"
    u.role = :admin
    u.password = "aaaaaaaa"
    u.password_confirmation = "aaaaaaaa"
  end

  # 一般ユーザー（各社9人 → 合計10人）
  9.times do |j|
    index = j + 1
    company.users.find_or_create_by!(email: "staff#{i + 1}-#{index}@example.com") do |u|
      u.name = "一般 ユーザー#{i + 1}-#{index}"
      u.role = :staff
      u.password = "aaaaaaaa"
      u.password_confirmation = "aaaaaaaa"
    end
  end

  # 部屋（各社3つ）
  ["会議室A", "会議室B", "応接室"].each do |room_name|
    company.rooms.find_or_create_by!(name: room_name)
  end
end

puts "Seed completed."
