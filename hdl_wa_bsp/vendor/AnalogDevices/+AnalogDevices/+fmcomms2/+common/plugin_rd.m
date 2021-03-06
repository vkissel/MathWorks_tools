function hRD = plugin_rd(board, design)
% Reference design definition

%   Copyright 2014-2015 The MathWorks, Inc.

% Construct reference design object
hRD = hdlcoder.ReferenceDesign('SynthesisTool', 'Xilinx Vivado');

% Create the reference design for the SOM-only
% This is the base reference design that other RDs can build upon
hRD.ReferenceDesignName = sprintf('FMCOMMS2/3 %s Base System (Vivado 2017.4)', upper(board));

% Determine the board name based on the design
hRD.BoardName = sprintf('AnalogDevices FMCOMMS2/3 %s (%s)', upper(board), design);

% Tool information
hRD.SupportedToolVersion = {'2017.4'};

% Get the root directory
rootDir = fileparts(strtok(mfilename('fullpath'), '+'));

% Design files are shared
hRD.SharedRD = true;
hRD.SharedRDFolder = fullfile(rootDir, 'vivado');

%% Add custom design files
% add custom Vivado design
switch(upper(design))
	case 'RX'
		hRD.addCustomVivadoDesign( ...
			'CustomBlockDesignTcl', fullfile('projects', 'fmcomms2', lower(board), 'system_project_rx.tcl'), ...
			'CustomTopLevelHDL',    fullfile('projects', 'fmcomms2', lower(board), 'system_top.v'));
	case 'TX'
		hRD.addCustomVivadoDesign( ...
			'CustomBlockDesignTcl', fullfile('projects', 'fmcomms2', lower(board), 'system_project_tx.tcl'), ...
			'CustomTopLevelHDL',    fullfile('projects', 'fmcomms2', lower(board), 'system_top.v'));
	case 'RX & TX'
		hRD.addCustomVivadoDesign( ...
			'CustomBlockDesignTcl', fullfile('projects', 'fmcomms2', lower(board), 'system_project_rx_tx.tcl'), ...
			'CustomTopLevelHDL',    fullfile('projects', 'fmcomms2', lower(board), 'system_top.v'));
	otherwise
		hRD.addCustomVivadoDesign( ...
			'CustomBlockDesignTcl', fullfile('projects', 'fmcomms2', lower(board), 'system_project.tcl'), ...
			'CustomTopLevelHDL',    fullfile('projects', 'fmcomms2', lower(board), 'system_top.v'));
end	

hRD.BlockDesignName = 'system';	
	
% custom constraint files
hRD.CustomConstraints = {...
    fullfile('projects', 'fmcomms2', lower(board), 'system_constr.xdc'), ...
    fullfile('projects', 'common', lower(board), sprintf('%s_system_constr.xdc', lower(board))), ...
    };

% custom source files
hRD.CustomFiles = {...
    fullfile('projects')...,
	fullfile('library')...,
    };	
	
%% Add interfaces
% add clock interface
hRD.addClockInterface( ...
    'ClockConnection',   'util_ad9361_divclk/clk_out', ...
    'ResetConnection',   'util_ad9361_divclk_reset/peripheral_aresetn');
	
