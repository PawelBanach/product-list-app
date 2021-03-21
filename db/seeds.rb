# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

tags = Tag.create(
  [
    { title: "Sparkle" },
    { title: "Still" },
  ]
)

Product.create(
  [
    { name: "Water", description:"24oz Bottle", price: 1.98, tags: tags },
    { name: "Wine", description:"24oz Bottle", price: 1.48, tags: tags },
  ]
)

