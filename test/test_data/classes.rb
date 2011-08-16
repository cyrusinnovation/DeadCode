class ImAClass
end

class IHaveBeenSubbed
end

class UsedByClassName
end

class JacobLikesPoop < IHaveBeenSubbed
  :class_name => "UsedByClassName"
  ImAClass.new
end
