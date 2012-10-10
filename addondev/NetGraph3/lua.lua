local fps_count = 0;
local down_kbps = 0;
local up_kbps = 0;
local down_kbps_t = 0;
local up_kbps_t = 0;
local bwps = 0;
local bandwidth = 0;
local lag = 0;
local counter = 0;
local delay = 1;

function NETGRAPH3_update_data()
	fps_count = tonumber(string.format("%.2f",GetFramerate()))
	down_kbps, up_kbps, lag = GetNetStats()
	down_kbps = tonumber(string.format("%.2f",down_kbps))
	up_kbps = tonumber(string.format("%.2f",up_kbps))
	down_kbps_t = down_kbps_t + down_kbps*delay
	up_kbps_t = up_kbps_t + up_kbps*delay
	bandwidth = up_kbps_t + down_kbps_t

	S_FPS:SetText( string.format("FPS: %.2f",fps_count) )
	S_DOWNKBPS:SetText( string.format("Down: %.2f kB/s",down_kbps) )
	S_UPKBPS:SetText( string.format("Up: %.2f kB/s",up_kbps) )
	S_TDOWNKB:SetText( string.format("Total down: %.2f kB",down_kbps_t) )
	S_TUPKB:SetText( string.format("Total up: %.2f kB",up_kbps_t) )
	S_TKB:SetText( string.format("Bandwidth used: %.2f kB",bandwidth) )
	S_LAG:SetText("Lag: "..lag.."ms")
end

function NETGRAPH3_OnUpdate(self, elapsed)
	counter = counter+elapsed
	if counter>=delay then
		NETGRAPH3_update_data()
		counter = 0
	end
end
