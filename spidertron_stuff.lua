function make_spidertron_leg(spidertron_name, scale, leg_thickness,
                             movement_speed, number, base_sprite, ending_sprite)
    return {
        type = "spider-leg",
        name = spidertron_name .. "-leg-" .. number,

        localised_name = {"entity-name.spidertron-leg"},
        collision_box = {{-0.05, -0.05}, {0.05, 0.05}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        icon = "__base__/graphics/icons/spidertron.png",
        icon_size = 64,
        icon_mipmaps = 4,
        walking_sound_volume_modifier = 0.6,
        target_position_randomisation_distance = 0.25 * scale,
        minimal_step_size = 1 * scale,
        working_sound = {
            match_progress_to_activity = true,
            sound = sounds.spidertron_leg,
            audible_distance_modifier = 0.5
        },
        part_length = 3.5 * scale,
        initial_movement_speed = 0.06 * movement_speed,
        movement_acceleration = 0.03 * movement_speed,
        max_health = 100,
        movement_based_position_selection_distance = 4 * scale,
        selectable_in_game = false,
        graphics_set = create_spidertron_leg_graphics_set(scale * leg_thickness,
                                                          number)
    }
end

function create_spidertron(arguments)
    local scale = arguments.scale
    local leg_scale = scale * arguments.leg_scale
    data:extend({
        {
            type = "spider-vehicle",
            name = arguments.name,
            collision_box = {{-1 * scale, -1 * scale}, {1 * scale, 1 * scale}},
            sticker_box = {
                {-1.5 * scale, -1.5 * scale}, {1.5 * scale, 1.5 * scale}
            },
            selection_box = {{-1 * scale, -1 * scale}, {1 * scale, 1 * scale}},
            drawing_box = {{-3 * scale, -4 * scale}, {3 * scale, 2 * scale}},
            icon = "__base__/graphics/icons/spidertron.png",
            mined_sound = {
                filename = "__core__/sound/deconstruct-large.ogg",
                volume = 0.8
            },
            open_sound = {
                filename = "__base__/sound/spidertron/spidertron-door-open.ogg",
                volume = 0.35
            },
            close_sound = {
                filename = "__base__/sound/spidertron/spidertron-door-close.ogg",
                volume = 0.4
            },
            sound_minimum_speed = 0.1,
            sound_scaling_ratio = 0.6,
            working_sound = {
                sound = {
                    filename = "__base__/sound/spidertron/spidertron-vox.ogg",
                    volume = 0.35
                },
                activate_sound = {
                    filename = "__base__/sound/spidertron/spidertron-activate.ogg",
                    volume = 0.5
                },
                deactivate_sound = {
                    filename = "__base__/sound/spidertron/spidertron-deactivate.ogg",
                    volume = 0.5
                },
                match_speed_to_activity = true
            },
            icon_size = 64,
            icon_mipmaps = 4,
            weight = 1,
            braking_force = 1,
            friction_force = 1,
            flags = {
                "placeable-neutral", "player-creation", "placeable-off-grid"
            },
            collision_mask = {},
            minable = {mining_time = 1, result = "spidertron"},
            max_health = 3000,
            resistances = {
                {type = "fire", decrease = 15, percent = 60},
                {type = "physical", decrease = 15, percent = 60},
                {type = "impact", decrease = 50, percent = 80},
                {type = "explosion", decrease = 20, percent = 75},
                {type = "acid", decrease = 0, percent = 70},
                {type = "laser", decrease = 0, percent = 70},
                {type = "electric", decrease = 0, percent = 70}
            },
            minimap_representation = {
                filename = "__base__/graphics/entity/spidertron/spidertron-map.png",
                flags = {"icon"},
                size = {128, 128},
                scale = 0.5
            },
            corpse = "spidertron-remnants",
            dying_explosion = "spidertron-explosion",
            energy_per_hit_point = 1,
            guns = {
                "spidertron-rocket-launcher-1", "spidertron-rocket-launcher-2",
                "spidertron-rocket-launcher-3", "spidertron-rocket-launcher-4"
            },
            inventory_size = 80,
            equipment_grid = "spidertron-equipment-grid",
            trash_inventory_size = 20,
            height = 1.5 * scale * leg_scale,
            torso_rotation_speed = 0.005,
            chunk_exploration_radius = 3,
            selection_priority = 51,
            graphics_set = spidertron_torso_graphics_set(scale),
            energy_source = {type = "void"},
            movement_energy_consumption = "250kW",
            automatic_weapon_cycling = true,
            chain_shooting_cooldown_modifier = 0.5,
            spider_engine = {
                legs = {
                    { -- 1
                        leg = arguments.name .. "-leg-1",
                        mount_position = util.by_pixel(15 * scale, -22 * scale), -- {0.5, -0.75},
                        ground_position = {2.25 * leg_scale, -2.5 * leg_scale},
                        blocking_legs = {2},
                        leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
                    }, { -- 2
                        leg = arguments.name .. "-leg-2",
                        mount_position = util.by_pixel(23 * scale, -10 * scale), -- {0.75, -0.25},
                        ground_position = {3 * leg_scale, -1 * leg_scale},
                        blocking_legs = {1, 3},
                        leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
                    }, { -- 3
                        leg = arguments.name .. "-leg-3",
                        mount_position = util.by_pixel(25 * scale, 4 * scale), -- {0.75, 0.25},
                        ground_position = {3 * leg_scale, 1 * leg_scale},
                        blocking_legs = {2, 4},
                        leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
                    }, { -- 4
                        leg = arguments.name .. "-leg-4",
                        mount_position = util.by_pixel(15 * scale, 17 * scale), -- {0.5, 0.75},
                        ground_position = {2.25 * leg_scale, 2.5 * leg_scale},
                        blocking_legs = {3},
                        leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
                    }, { -- 5
                        leg = arguments.name .. "-leg-5",
                        mount_position = util.by_pixel(-15 * scale, -22 * scale), -- {-0.5, -0.75},
                        ground_position = {-2.25 * leg_scale, -2.5 * leg_scale},
                        blocking_legs = {6, 1},
                        leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
                    }, { -- 6
                        leg = arguments.name .. "-leg-6",
                        mount_position = util.by_pixel(-23 * scale, -10 * scale), -- {-0.75, -0.25},
                        ground_position = {-3 * leg_scale, -1 * leg_scale},
                        blocking_legs = {5, 7},
                        leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
                    }, { -- 7
                        leg = arguments.name .. "-leg-7",
                        mount_position = util.by_pixel(-25 * scale, 4 * scale), -- {-0.75, 0.25},
                        ground_position = {-3 * leg_scale, 1 * leg_scale},
                        blocking_legs = {6, 8},
                        leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
                    }, { -- 8
                        leg = arguments.name .. "-leg-8",
                        mount_position = util.by_pixel(-15 * scale, 17 * scale), -- {-0.5, 0.75},
                        ground_position = {-2.25 * leg_scale, 2.5 * leg_scale},
                        blocking_legs = {7},
                        leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
                    }
                },
                military_target = "spidertron-military-target"
            }
        },
        make_spidertron_leg(arguments.name, leg_scale, arguments.leg_thickness,
                            arguments.leg_movement_speed, 1),
        make_spidertron_leg(arguments.name, leg_scale, arguments.leg_thickness,
                            arguments.leg_movement_speed, 2),
        make_spidertron_leg(arguments.name, leg_scale, arguments.leg_thickness,
                            arguments.leg_movement_speed, 3),
        make_spidertron_leg(arguments.name, leg_scale, arguments.leg_thickness,
                            arguments.leg_movement_speed, 4),
        make_spidertron_leg(arguments.name, leg_scale, arguments.leg_thickness,
                            arguments.leg_movement_speed, 5),
        make_spidertron_leg(arguments.name, leg_scale, arguments.leg_thickness,
                            arguments.leg_movement_speed, 6),
        make_spidertron_leg(arguments.name, leg_scale, arguments.leg_thickness,
                            arguments.leg_movement_speed, 7),
        make_spidertron_leg(arguments.name, leg_scale, arguments.leg_thickness,
                            arguments.leg_movement_speed, 8)
    })
end

function get_leg_hit_the_ground_trigger()
    return
      {
        {
          type = "create-trivial-smoke",
          smoke_name = "smoke-building",
          repeat_count = 4,
          starting_frame_deviation = 5,
          starting_frame_speed_deviation = 5,
          offset_deviation = {{-0.2, -0.2}, {0.2, 0.2}},
          speed_from_center = 0.03
        }
      }
  end

-- RELIC COMMENT: CALLING THE FUNCTION

create_spidertron {
    name = "spidertron",
    scale = 1,
    leg_scale = 1, -- relative to scale
    leg_thickness = 1, -- relative to leg_scale
    leg_movement_speed = 1
}

--[[
    RELIC COMMENT: THIS IS TAKEN FROM KLONAN'S COMPANION DRONE MOD 
--]]

local scale = 0.6
local leg_scale = 1
local arguments = {name = "spidertron"}
local drone =
{
  type = "spider-vehicle",
  name = "companion",
  localised_name = {"companion"},
  collision_box = {{-1 * scale, -1 * scale}, {1 * scale, 1 * scale}},
  selection_box = {{-1 * scale, -1 * scale}, {1 * scale, 1 * scale}},
  drawing_box = {{-3 * scale, -4 * scale}, {3 * scale, 2 * scale}},
  icon = "__Companion_Drones__/drone-icon.png",
  icon_size = 200,
  mined_sound = {filename = "__core__/sound/deconstruct-large.ogg",volume = 0.8},
  open_sound = { filename = "__base__/sound/spidertron/spidertron-door-open.ogg", volume= 0.35 },
  close_sound = { filename = "__base__/sound/spidertron/spidertron-door-close.ogg", volume = 0.4 },
  sound_minimum_speed = 0.3,
  sound_scaling_ratio = 0.1,
  allow_passengers = false,
  working_sound =
  {
    sound =
    {
      filename = "__base__/sound/spidertron/spidertron-vox.ogg",
      volume = 0.35
    },
    activate_sound =
    {
      filename = "__base__/sound/spidertron/spidertron-activate.ogg",
      volume = 0.5
    },
    deactivate_sound =
    {
      filename = "__base__/sound/spidertron/spidertron-deactivate.ogg",
      volume = 0.5
    },
    match_speed_to_activity = true
  },
  weight = 1,
  braking_force = 1,
  friction_force = 1,
  flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
  collision_mask = {},
  minable = {result = "companion", mining_time = 1},
  max_health = 250,
  resistances =
  {
    {
      type = "fire",
      decrease = 15,
      percent = 60
    },
    {
      type = "physical",
      decrease = 15,
      percent = 60
    },
    {
      type = "impact",
      decrease = 50,
      percent = 80
    },
    {
      type = "explosion",
      decrease = 20,
      percent = 75
    },
    {
      type = "acid",
      decrease = 0,
      percent = 70
    },
    {
      type = "laser",
      decrease = 0,
      percent = 70
    },
    {
      type = "electric",
      decrease = 0,
      percent = 70
    }
  },
  --corpse = "spidertron-remnants",
  --dying_explosion = "spidertron-explosion",
  energy_per_hit_point = 1,
  guns = {},
  inventory_size = 21,
  equipment_grid = "companion-equipment-grid",
  trash_inventory_size = 0,
  height = 2,
  torso_rotation_speed = 0.05,
  chunk_exploration_radius = 3,
  selection_priority = 45,
  graphics_set = spidertron_torso_graphics_set(0.6),
  base_render_layer = "smoke",
  render_layer = "air-object",
  energy_source =
  {
    type = "burner",
    fuel_category = "chemical",
    effectivity = 1,
    fuel_inventory_size = 3,
    smoke =
    {
      {
        name = "train-smoke",
        deviation = {0.3, 0.3},
        frequency = 100,
        position = {0, 0},
        starting_frame = 0,
        starting_frame_deviation = 60,
        height = 2,
        height_deviation = 0.5,
        starting_vertical_speed = -0.2,
        starting_vertical_speed_deviation = 0.1
      }
    }
  },
  movement_energy_consumption = "20kW",
  automatic_weapon_cycling = true,
  chain_shooting_cooldown_modifier = 0.5,
  spider_engine =
  {
    legs =
    {
      {
        leg = "companion-leg",
        mount_position = {0, -1},
        ground_position = {0, -1},
        blocking_legs = {1},
        leg_hit_the_ground_trigger = nil
      }
       --[[ RELIC COMMENT: this needs a table for each leg:
      {leg = "companion-leg", mount_position = {0, -1}, ground_position = {0, -1}, blocking_legs = {1}, leg_hit_the_ground_trigger = nil},
      {leg = "companion-leg", mount_position = {0, -1}, ground_position = {0, -1}, blocking_legs = {1}, leg_hit_the_ground_trigger = nil},
      {leg = "companion-leg", mount_position = {0, -1}, ground_position = {0, -1}, blocking_legs = {1}, leg_hit_the_ground_trigger = nil},
      {leg = "companion-leg", mount_position = {0, -1}, ground_position = {0, -1}, blocking_legs = {1}, leg_hit_the_ground_trigger = nil},
      {leg = "companion-leg", mount_position = {0, -1}, ground_position = {0, -1}, blocking_legs = {1}, leg_hit_the_ground_trigger = nil},
      {leg = "companion-leg", mount_position = {0, -1}, ground_position = {0, -1}, blocking_legs = {1}, leg_hit_the_ground_trigger = nil}
      --]]
    },
    military_target = "spidertron-military-target"
  },

  minimap_representation =
  {
    filename = "__Companion_Drones__/drone-map.png",
    flags = {"icon"},
    size = {128, 128},
    scale = 0.25
  }

}

drone.graphics_set.render_layer = "air-entity-info-icon"
drone.graphics_set.base_render_layer = "air-object"
drone.graphics_set.autopilot_path_visualisation_line_width = 0
drone.graphics_set.autopilot_path_visualisation_on_map_line_width = 0
drone.graphics_set.autopilot_destination_visualisation = util.empty_sprite()
drone.graphics_set.autopilot_destination_queue_on_map_visualisation = util.empty_sprite()
drone.graphics_set.autopilot_destination_on_map_visualisation = util.empty_sprite()
drone.graphics_set.light =
{
  {
    type = "oriented",
    minimum_darkness = 0.3,
    picture =
    {
      filename = "__core__/graphics/light-cone.png",
      priority = "extra-high",
      flags = { "light" },
      scale = 1,
      width = 200,
      height = 200,
      shift = {0, -1}
    },
    source_orientation_offset = 0,
    shift = {0, (-200/32)- 0.5},
    add_perspective = false,
    size = 2,
    intensity = 0.6,
    color = {r = 0.92, g = 0.77, b = 0.3}
  }
}
drone.graphics_set.eye_light.size = 0

local leg =
{
  type = "spider-leg",
  name = "companion-leg",

  localised_name = {"entity-name.spidertron-leg"},
  collision_box = nil,
  collision_mask = {},
  selection_box = {{-0, -0}, {0, 0}},
  icon = "__base__/graphics/icons/spidertron.png",
  icon_size = 64, icon_mipmaps = 4,
  walking_sound_volume_modifier = 0,
  target_position_randomisation_distance = 0,
  minimal_step_size = 0,
  working_sound = nil,
  part_length = 1000000000,
  initial_movement_speed = 100,
  movement_acceleration = 100,
  max_health = 100,
  movement_based_position_selection_distance = 3,
  selectable_in_game = false,
  graphics_set = create_spidertron_leg_graphics_set(0, 1)
}

local layers = drone.graphics_set.base_animation.layers
for k, layer in pairs (layers) do
  layer.repeat_count = 8
  layer.hr_version.repeat_count = 8
end

table.insert(layers, 1,
{
  filename = "__base__/graphics/entity/rocket-silo/10-jet-flame.png",
  priority = "medium",
  blend_mode = "additive",
  draw_as_glow = true,
  width = 87,
  height = 128,
  frame_count = 8,
  line_length = 8,
  animation_speed = 0.5,
  scale = 1.13/4,
  shift = util.by_pixel(-0.5, 20),
  direction_count = 1,
  hr_version = {
    filename = "__base__/graphics/entity/rocket-silo/hr-10-jet-flame.png",
    priority = "medium",
    blend_mode = "additive",
    draw_as_glow = true,
    width = 172,
    height = 256,
    frame_count = 8,
    line_length = 8,
    animation_speed = 0.5,
    scale = 1.13/8,
    shift = util.by_pixel(-1, 20),
    direction_count = 1,
  }
})