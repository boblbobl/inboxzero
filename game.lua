function showgame()
  top = 11
  email_h = 30
  email_w = 128
  email_state = 0
  email_offset = 0
  state_offset = 30
  anim_frames = 6
  camera_offset = 0
  deleting = false

  emails = get_emails(99, 1)
  scene.update = update_game
  scene.draw = draw_game
end

function update_game()
  if btnp(1) then -- swipe right
    if (email_state == 0) then
      email_state = 1
    elseif email_state == 2 then
      email_state = 0
    end
  end
  if btnp(0) then -- swipe left
    if (email_state == 0) then
      email_state = 2
    elseif email_state == 1 then
      email_state = 0
    end
  end

  if btnp(4) and email_state > 0 then
    deleting = true
  end

  if (deleting) then
    if camera_offset < email_h then
      camera_offset += anim_frames
    else
      -- reset email state
      email_state = 0
      email_offset = 0
      -- delete email
      del(emails, emails[1])
      -- reset camera
      camera()
      camera_offset = 0
      -- set deleting to false
      deleting = false
    end
  end

  if email_state == 1 and email_offset < state_offset then
    email_offset += anim_frames
  elseif email_state == 2 and email_offset > -state_offset then
    email_offset -= anim_frames
  elseif email_state == 0 and email_offset ~= 0 then
      if email_offset < 0 then
        email_offset += anim_frames
      elseif email_offset > 0 then
        email_offset -= anim_frames
      end
  end
end

function draw_hint()
  if email_state > 0 and deleting == false then
    rectfill(0, 115, 127, 127, 1)
    print("press \142 to confirm", 26, 119, 7)
  end
end

function draw_email(idx, email)
  local y = (idx*email_h) + top

  if (idx == 0) then
    rectfill(email_offset, y, email_w + email_offset, y + email_h, 7)
    spr(email.avatar, 3+email_offset, y+4)
    print(email.subject, 16+email_offset, y+5, 5)
    print(email.body, 16+email_offset, y+14, 6)
  else
    rectfill(0, y, email_w, y + email_h, 7)
    line(0, y, email_w, y, 6)
    spr(email.avatar, 3, y+4)
    print(email.subject, 16, y+5, 5)
    print(email.body, 16, y+14, 6)
  end
end

function draw_statusbar()
  rectfill(0, camera_offset, 127, 10+camera_offset, 0)
  spr(1, 1, 2+camera_offset)
  spr(17, 8, 2+camera_offset)
  spr(18, 16, 2+camera_offset)
  spr(19, 24, 2+camera_offset)
  print(#emails, 16, 3+camera_offset, 7)
  print("09:00 AM", 50, 3+camera_offset, 7)
  spr(2, 108, 2+camera_offset)
  spr(3, 118, 2+camera_offset)
end

function draw_game()
  cls(0)

  if #emails > 0 then
    rectfill(64,top,email_w,email_h+top-1,3)
    rectfill(0,top,email_w-64,email_h+top-1,8)
    spr(33, 10, 22)
    spr(34, 110, 22)

    local i = 0
    while (i < 5 and i < #emails) do
      draw_email(i, emails[i+1])
      i += 1
    end

    draw_hint()
  end

  camera(0, camera_offset)
  draw_statusbar()
end
