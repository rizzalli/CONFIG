# Home Assistant Configuration - TODO List

## 🔴 High Priority - Testing & Validation

### Dashboard Testing (3-7 Days)
- [ ] **Day 1-2**: Test all three dashboards (Minimalist, Card-Based, Functional)
- [ ] **Day 3-5**: Focus on your favorite dashboard for daily use
- [ ] **Day 6-7**: Final comparison and decision
- [ ] **After testing**: Provide feedback on:
  - Which dashboard do you prefer?
  - What features from the others do you want added?
  - What didn't you like?
  - Any new features you wish you had?

### Configuration Validation
- [ ] Verify health sensors show actual numbers (not "unavailable")
  - `sensor.unavailable_entities` should show count
  - `sensor.automations_off` should show count
- [ ] Verify uptime sensor appears in System Info
  - `sensor.uptime` shows HA restart time
  - Different from Raspberry Pi boot time
- [ ] Test climate calibration controls
  - `number.living_room_air_conditioner_temperature_calibration`
  - `number.living_room_air_conditioner_humidity_calibration`
- [ ] Test Admin & Dev dashboard buttons:
  - [ ] Git Sync button
  - [ ] System Maintenance button
  - [ ] Backup button
  - [ ] Recorder Purge buttons (30/90/180/365 days)
  - [ ] Check Configuration button
  - [ ] Restart/Reload buttons

## 🟡 Medium Priority - Configuration & Enhancement

### Energy Analytics Setup
- [ ] **Configure actual energy sensor** in `utility_meter.yaml`
  - Replace placeholder `sensor.energy_consumption` with real entity
  - Requirements: Must be in kWh with `state_class: total_increasing`
  - Current status: Scaffolding is in place, needs real sensor
- [ ] **Optional**: Add solar production meters if you have solar panels
  - Uncommented examples exist in `utility_meter.yaml`

### Long-term Data Analysis
- [ ] Review history_stats sensors after 30 days of data collection
  - Floor Lamp usage patterns
  - TV Light usage patterns
  - Kitchen Bench usage patterns
  - Kitchen Strip usage patterns
  - Bedroom Light usage patterns
- [ ] Create dashboards/automations based on usage patterns

### Live Monitoring / Logs
- [ ] **Research solution for live log viewing**
  - Original request: "see some kinda live status / logs...so when i run a script...see what it is doing"
  - File platform sensors deprecated (removed)
  - Possible alternatives:
    - Use built-in HA Logs (Settings → System → Logs)
    - Investigate Logbook integration
    - Consider command_line sensors for specific log tails
    - Look into third-party add-ons (e.g., Log Viewer add-on)

## 🟢 Low Priority - Future Enhancements

### Optional Helper Entities
- [ ] Review `dashboards/optional_helpers.yaml` for useful additions:
  - Input booleans for automation modes
  - Input numbers for thresholds
  - Input selects for scene selection
  - Input datetime for scheduling

### Dashboard Optimization
- [ ] After testing period, create custom optimized dashboard
  - Combine best elements from all three test dashboards
  - Tailored to your specific usage patterns
  - Based on your feedback and preferences

### Automation Ideas
- [ ] Room-based automation improvements based on usage data
- [ ] Smart climate control based on patterns
- [ ] Light automation based on time-of-day usage stats

### System Monitoring
- [ ] Consider adding additional system sensors if needed:
  - Network monitoring
  - CPU temperature alerts
  - Disk space alerts
  - Database size monitoring

## 📝 Documentation & Maintenance

### Regular Tasks
- [ ] Weekly: Review unavailable entities count
- [ ] Weekly: Check automations off count
- [ ] Monthly: Review database size and consider purge
- [ ] Monthly: Test backup restoration process
- [ ] Quarterly: Review and update automations based on usage

### Git Workflow
- [x] Git auto-sync on HA startup (✅ Configured)
- [x] Git auto-sync nightly at 2 AM (✅ Configured)
- [ ] Consider adding automatic backups to separate repo/location

### Known Issues Resolved ✅
- [x] ~~Air purifier entity ID typo~~ (Fixed: `air_purifer` → `air_purifier`)
- [x] ~~Deprecated file platform sensors~~ (Removed)
- [x] ~~YAML syntax errors~~ (Fixed)
- [x] ~~Git sync script stray characters~~ (Fixed)
- [x] ~~Maintenance script logging secrets~~ (Fixed)
- [x] ~~Git history with exposed tokens~~ (Cleaned with filter-branch)
- [x] ~~Unsupported custom cards~~ (Removed: slider-entity-row, bar-card, fold-entity-row, grid-layout)
- [x] ~~System monitor entity ID prefixes~~ (Fixed to use `sensor.system_monitor_*`)
- [x] ~~Health sensors showing "unavailable"~~ (Fixed: added unit_of_measurement)

## 🎯 Next Immediate Actions

1. **Restart Home Assistant** to load all new configurations
2. **Verify all dashboards load** without errors
3. **Check System Info** shows both Pi boot time and HA uptime
4. **Test health sensors** display actual counts
5. **Review climate calibration controls** are available
6. **Begin 3-7 day dashboard testing period**

---

**Last Updated:** November 9, 2025  
**Status:** All current tasks completed and committed (commit `12c9528`)  
**Workflow:** Edit locally → Git push → HA auto-pulls on startup/nightly → Restart HA
