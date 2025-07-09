# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HeadsUp.Repo.insert!(%HeadsUp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HeadsUp.Repo
alias HeadsUp.Incidents.Incident
alias HeadsUp.Categories.Category

animals =
  %Category{name: "Animals & Wildlife", slug: "animals-and-wildlife"}
  |> Repo.insert!()

technology =
  %Category{name: "Technology", slug: "technology"}
  |> Repo.insert!()

vehicles =
  %Category{name: "Vehicles", slug: "vehicles"}
  |> Repo.insert!()

nature =
  %Category{name: "Nature", slug: "nature"}
  |> Repo.insert!()

%Incident{
  name: "Lost Dog",
  description: """
  A friendly dog is wandering around the neighborhood, looking a bit confused and out of place. He seems to have lost his way and could really use a little help finding his way back home! 🐶
  """,
  priority: 2,
  status: :pending,
  image_path: "/images/lost-dog.jpg",
  category: animals
}
|> Repo.insert!()

%Incident{
  name: "Tree Down On Roadway",
  description: """
  A hefty tree toppled over and is now lounging across the road! We need some extra hands to move this leafy roadblock and get things moving again. 🌲
  """,
  priority: 1,
  status: :canceled,
  image_path: "/images/tree-down.jpg",
  category: nature
}
|> Repo.insert!()

%Incident{
  name: "Snowplow Stuck",
  description: """
  Looks like our trusty snowplow got a little too cozy with the snow and is now stuck! If you've got some muscle and a shovel, we could use a hand to set it free! ❄️
  """,
  priority: 2,
  status: :pending,
  image_path: "/images/snowplow-stuck.jpg",
  category: vehicles
}
|> Repo.insert!()

%Incident{
  name: "Website Down",
  description: """
  Yikes! The community website has taken an unscheduled nap and needs a little TLC to get back online. If you can lend a tech-savvy hand, we'd really appreciate the assist! 🔥
  """,
  priority: 2,
  status: :resolved,
  image_path: "/images/website-down.jpg",
  category: technology
}
|> Repo.insert!()

%Incident{
  name: "Bear In The Trash",
  description: """
  A curious bear is digging through the trash, like it's his own personal buffet. He's making quite the mess but looks too pleased with his scavenger hunt to care! 🐻
  """,
  priority: 1,
  status: :canceled,
  image_path: "/images/bear-in-trash.jpg",
  category: animals
}
|> Repo.insert!()

%Incident{
  name: "Overactive Pumpkin Patch",
  description: """
  Our pumpkin patch went into overdrive and now we've got pumpkins galore! Come on over and grab a few. Let's share the pumpkin love with the whole community! 🎃
  """,
  priority: 2,
  status: :resolved,
  image_path: "/images/pumpkin-patch.jpg",
  category: nature
}
|> Repo.insert!()

%Incident{
  name: "Moose On The Loose",
  description: """
  A big ol' moose is on the loose, wandering through the neighborhood like he owns the place. He's turning heads and causing quite a stir, probably just looking for a snack or some new scenery! 🫎
  """,
  priority: 3,
  status: :pending,
  image_path: "/images/moose-on-loose.jpg",
  category: animals
}
|> Repo.insert!()

%Incident{
  name: "Flat Tire",
  description: """
  Uh-oh! Our beloved ice cream truck has a flat tire and needs a helping hand to get back on the road. The treats are melting, and we need some quick assistance to save the day! 🛞
  """,
  priority: 1,
  status: :resolved,
  image_path: "/images/flat-tire.jpg",
  category: vehicles
}
|> Repo.insert!()

%Incident{
  name: "Cat Stuck In Tree",
  description: """
  A mischievous cat is stuck high in a tree, meowing loudly for some assistance. He's realizing that his grand adventure up the branches might need a little human intervention to get back down! 🙀
  """,
  priority: 3,
  status: :resolved,
  image_path: "/images/cat-in-tree.jpg",
  category: animals
}
|> Repo.insert!()

%Incident{
  name: "Annoying Drone",
  description: """
  There's an obnoxious drone buzzing around like an over-caffeinated mosquito. It's causing quite a ruckus and making everyone look up and groan! 🛸
  """,
  priority: 3,
  status: :pending,
  image_path: "/images/annoying-drone.jpg",
  category: technology
}
|> Repo.insert!()

%Incident{
  name: "Washed-Out Trail",
  description: """
  The heavy rains have turned our favorite hiking trail into a muddy mess! A little repair work will have it back in hiking shape in no time. 💦
  """,
  priority: 3,
  status: :pending,
  image_path: "/images/washed-out-trail.jpg",
  category: nature
}
|> Repo.insert!()

%Incident{
  name: "Suspicious Vehicle",
  description: """
  There's a clownish vehicle cruising around, looking like it rolled straight out of a circus. It's raising a few eyebrows, so maybe it's time for a friendly check to see what's up! 🤡
  """,
  priority: 3,
  status: :canceled,
  image_path: "/images/suspicious-vehicle.jpg",
  category: vehicles
}
|> Repo.insert!()
