
let hmac_md5 sec see = sec
let hmac_sha sec see = sec

let rec p_md5 len secret a seed =
  let res = hmac_md5 secret (a ^ seed) in
  if len > 16 then
    res ^ (p_md5 (len - 16) secret res seed)
  else
    res

let rec p_sha len secret a seed =
  let res = hmac_sha secret (a ^ seed) in
  if len > 16 then
    res ^ (p_sha (len - 20) secret res seed)
  else
    res

let halve secret =
  let len = String.length secret in
  (String.sub secret 0 (len / 2),
   String.sub secret (len / 2) len)

let pseudo_random_function len secret label seed =
  let s1, s2 = halve secret in
  let md5 = p_md5 len s1 seed (label ^ seed) in
  let sha = p_sha len s2 seed (label ^ seed) in
  (* xor_string md5 sha *)
  sha

let generate_master_secret pre_master_secret seed =
  pseudo_random_function 48 pre_master_secret "master secret" seed

let key_block len master_secret seed =
  pseudo_random_function len master_secret "key expansion" seed

