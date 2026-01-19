-- axis-aligned bounding box collision detection
function aabb_collide(x1, y1, w1, h1, x2, y2, w2, h2)
  if x1 < x2 + w2 and
     x1 + w1 > x2 and
     y1 < y2 + h2 and
     y1 + h1 > y2 then
    return true
  else
    return false
  end
end

function map_collide(x, y, w, h, dx, dy)
  x = x + dx
  y = y + dy

  s1 = mget(flr(x/8), flr(y/8))
  s2 = mget(flr((x+w-1)/8), flr(y/8))
  s3 = mget(flr(x/8), flr((y+h-1)/8))
  s4 = mget(flr((x+w-1)/8), flr((y+h-1)/8))

  if fget(s1) == 1 then
    return true
  elseif fget(s2) == 1 then
    return true
  elseif fget(s3) == 1 then
    return true
  elseif fget(s4) == 1 then
    return true
  end

  return false
end

function get_emails(count, difficulty)
  local emails = {}
  local pool = {}
  
  -- filter by difficulty
  for template in all(email_templates) do
    if template.difficulty <= difficulty then
      add(pool, template)
    end
  end
  
  -- shuffle and select emails
  for i = 1, min(count, #pool) do
    local idx = rand(1, #pool + 1)
    local template = pool[idx]
    add(emails, {
      subject=template.subject,
      body=template.body,
      avatar=template.avatar,
      action=template.action,
      difficulty=template.difficulty
    })
    del(pool, template)
  end
  
  return emails
end


function get_pickups(map_w, map_h, flag)
  local pickups = {}

  for i = 0, map_w-1 do
    for j = 0, map_h-1 do
      local tile = mget(i,j)
      if fget(tile) == flag then
        add(pickups, {x=i*8, y=j*8, s=tile})
        mset(i,j,0)
      end
    end
  end

  return pickups
end

windows={}
function new_window(x, y, w, h, text)
  local w={x=x, y=y, w=w, h=h, text=text}
  add(windows,w)
  return w
end

function draw_windows()
 for w in all(windows) do
  local wx,wy,ww,wh=w.x,w.y,w.w,w.h
  rectfill2(wx,wy,ww,wh,0)
  rectfill2(wx+1,wy+1,ww-2,wh-2,6)
  rectfill2(wx+2,wy+2,ww-4,wh-4,0)
  wx=wx+4
  wy=wy+4
--  clip(wx,wy,ww-8,wh-8)
  -- for i=1,#w.text do
  --  local txt=w.text[i]
  print(w.text,wx,wy,6)
   -- wy=wy+6
  -- end
 end
end

-- random int between i and j
function rand(i, j)
  if (j) then
    return flr(rnd(j-i))+i
  else
    return flr(rnd(i))
  end
end

function rectfill2(x, y, w, h, c)
  rectfill(x, y, x+(w-1), y+(h-1), c)
end
