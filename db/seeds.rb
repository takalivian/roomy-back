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
  rooms = ["会議室A", "会議室B", "応接室"].map do |room_name|
    company.rooms.find_or_create_by!(name: room_name)
  end

  admin_user = company.users.admin.first
  staff_user = company.users.staff.first

  # 予約（各社の部屋にサンプル予約を追加）
  # 日付が被らないように、同じ部屋の予約は時間帯をずらして作成
  base_day = Time.current.change(hour: 9, min: 0, sec: 0)

  # 会議室A: 2件の予約
  if rooms[0] && admin_user
    r1 = rooms[0].reservations.find_or_create_by!(
      user: admin_user,
      start_time: base_day,
      end_time: base_day + 1.hour,
      title: "定例MTG（#{company.name}）"
    ) do |r|
      r.remarks = "週次の定例ミーティングです"
    end

    r2 = rooms[0].reservations.find_or_create_by!(
      user: admin_user,
      start_time: base_day + 2.hours,
      end_time: base_day + 3.hours,
      title: "プロジェクト会議（#{company.name}）"
    ) do |r|
      r.remarks = "プロジェクト状況の共有"
    end

    # 参加者としてスタッフも追加
    if staff_user
      [r1, r2].compact.each do |reservation|
        reservation.reservation_participants.find_or_create_by!(user: admin_user)
        reservation.reservation_participants.find_or_create_by!(user: staff_user)
      end
    end
  end

  # 会議室B: 1件の予約
  if rooms[1] && staff_user
    r3 = rooms[1].reservations.find_or_create_by!(
      user: staff_user,
      start_time: base_day + 4.hours,
      end_time: base_day + 5.hours,
      title: "1on1 ミーティング（#{company.name}）"
    ) do |r|
      r.remarks = "上長との1on1"
    end
  end

  # 応接室: あえて予約なし（空の部屋例）
end

puts "Seed completed."
