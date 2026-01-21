-- menu screen
function showmenu()
  menu_selection = 1 -- 1=start, 2=credits
  scene.update = update_menu
  scene.draw = draw_menu
end

function update_menu()
  if btnp(2) and menu_selection > 1 then
    menu_selection -= 1
  end
  if btnp(3) and menu_selection < 2 then
    menu_selection += 1
  end
  
  if btnp(4) then -- z button
    if menu_selection == 1 then
      showgame()
    else
      showcredits()
    end
  end
end

function draw_menu()
  cls(0)

  -- logo
  spr(128, 30, 10, 8, 4)
  
  
  -- menu options
  local start_color = menu_selection == 1 and 11 or 7
  local credits_color = menu_selection == 2 and 11 or 7
  
  print("start game", 42, 60, start_color)
  print("credits", 48, 70, credits_color)
  
  -- cursor
  local cursor_y = menu_selection == 1 and 60 or 70
  print("\x8e", 32, cursor_y, 11)
end

-- credits screen
function showcredits()
  scene.update = update_credits
  scene.draw = draw_credits
end

function update_credits()
  if btnp(4) or btnp(5) then -- z or x button
    showmenu()
  end
end

function draw_credits()
  cls(0)
  
  print("inbox zero", 42, 20, 11)
  print("a pico-8 game", 33, 30, 7)
  print("", 0, 40, 7)
  print("game by boblbobl", 24, 50, 7)
  print("", 0, 58, 7)
  print("pixel art by hatch", 21, 68, 7)
  print("pixeljoint.com", 30, 76, 6)
  print("", 0, 86, 7)
  print("press \x8e to return", 24, 100, 11)
end

function showgame(level)
  level = level or 1
  current_level = level
  
  -- initialize total_score on first level
  if level == 1 then
    total_score = 0
  end
  
  top = 11
  email_h = 30
  email_w = 128
  email_state = 0
  email_offset = 0
  state_offset = 30
  anim_frames = 6
  camera_offset = 0
  deleting = false
  
  -- scoring system
  score = 0
  correct = 0
  incorrect = 0
  feedback_msg = ""
  feedback_timer = 0
  feedback_color = 7

  -- 10 emails per level, difficulty increases
  emails = get_emails(10, level)
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
      -- check if action was correct
      local email = emails[1]
      local player_action = email_state == 2 and "keep" or "delete"
      
      if player_action == email.action then
        score += 10
        correct += 1
        feedback_msg = "correct!"
        feedback_color = 11
      else
        score -= 5
        incorrect += 1
        if email.action == "keep" then
          feedback_msg = "oops! needed that"
        else
          feedback_msg = "that was spam!"
        end
        feedback_color = 8
      end
      feedback_timer = 30
      
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
  
  -- update feedback timer
  if feedback_timer > 0 then
    feedback_timer -= 1
  end
  
  -- check for level complete and progress immediately
  if #emails == 0 then
    total_score += score
    if current_level < 3 then
      showgame(current_level + 1)
    else
      showgameover()
    end
    return
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
  print("lvl"..current_level, 42, 3+camera_offset, 7)
  print("score:"..score, 62, 3+camera_offset, 7)
  spr(2, 108, 2+camera_offset)
  spr(3, 118, 2+camera_offset)
end

function draw_feedback()
  if feedback_timer > 0 then
    local msg_w = #feedback_msg * 4
    local x = 64 - (msg_w / 2)
    rectfill(x-2, 50, x+msg_w+2, 58, 0)
    print(feedback_msg, x, 52, feedback_color)
  end
end

-- game over screen
function showgameover()
  scene.update = update_gameover
  scene.draw = draw_gameover
end

function update_gameover()
  if btnp(4) or btnp(5) then -- z or x button
    showmenu()
  end
end

function draw_gameover()
  cls(0)
  
  print("game over", 42, 30, 11)
  print("", 0, 38, 7)
  print("final score", 38, 50, 7)
  print(tostr(total_score), 58, 60, 11)
  print("", 0, 70, 7)
  
  -- rank based on score
  local rank = "intern"
  local rank_color = 8
  if total_score >= 250 then
    rank = "ceo"
    rank_color = 11
  elseif total_score >= 200 then
    rank = "manager"
    rank_color = 10
  elseif total_score >= 150 then
    rank = "senior"
    rank_color = 9
  elseif total_score >= 100 then
    rank = "employee"
    rank_color = 12
  end
  
  print("rank: "..rank, 44, 80, rank_color)
  print("", 0, 90, 7)
  print("press \x8e to menu", 30, 105, 7)
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

  draw_feedback()
  camera(0, camera_offset)
  draw_statusbar()
end
