{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 8,
			"minor" : 5,
			"revision" : 1,
			"architecture" : "x64",
			"modernui" : 1
		}
,
		"classnamespace" : "box",
		"rect" : [ 93.0, 100.0, 1311.0, 807.0 ],
		"bglocked" : 0,
		"openinpresentation" : 0,
		"default_fontsize" : 12.0,
		"default_fontface" : 0,
		"default_fontname" : "Arial",
		"gridonopen" : 1,
		"gridsize" : [ 15.0, 15.0 ],
		"gridsnaponopen" : 1,
		"objectsnaponopen" : 1,
		"statusbarvisible" : 2,
		"toolbarvisible" : 1,
		"lefttoolbarpinned" : 0,
		"toptoolbarpinned" : 0,
		"righttoolbarpinned" : 0,
		"bottomtoolbarpinned" : 0,
		"toolbars_unpinned_last_save" : 0,
		"tallnewobj" : 0,
		"boxanimatetime" : 200,
		"enablehscroll" : 1,
		"enablevscroll" : 1,
		"devicewidth" : 0.0,
		"description" : "",
		"digest" : "",
		"tags" : "",
		"style" : "",
		"subpatcher_template" : "",
		"assistshowspatchername" : 0,
		"boxes" : [ 			{
				"box" : 				{
					"id" : "obj-36",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "multichannelsignal" ],
					"patching_rect" : [ 1185.0, 765.0, 40.0, 22.0 ],
					"text" : "mc.*~"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-35",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1245.0, 765.0, 69.0, 22.0 ],
					"text" : "receive wet"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-34",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "multichannelsignal" ],
					"patching_rect" : [ 75.0, 765.0, 40.0, 22.0 ],
					"text" : "mc.*~"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-33",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 150.0, 765.0, 67.0, 22.0 ],
					"text" : "receive dry"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-66",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 735.0, 180.0, 81.0, 22.0 ],
					"text" : "receive triode"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-67",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 735.0, 210.0, 89.0, 22.0 ],
					"text" : "prepend Triode"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-64",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 855.0, 180.0, 64.0, 22.0 ],
					"text" : "receive air"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-65",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 855.0, 210.0, 70.0, 22.0 ],
					"text" : "prepend Air"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-59",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 360.0, 105.0, 77.0, 22.0 ],
					"text" : "receive teote"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-63",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 360.0, 135.0, 78.0, 22.0 ],
					"text" : "prepend 1FX"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-52",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 615.0, 180.0, 94.0, 22.0 ],
					"text" : "receive pentode"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-55",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 615.0, 210.0, 101.0, 22.0 ],
					"text" : "prepend Pentode"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-49",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 480.0, 180.0, 103.0, 22.0 ],
					"text" : "receive saturation"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-50",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 480.0, 210.0, 111.0, 22.0 ],
					"text" : "prepend Saturation"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-48",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 360.0, 180.0, 84.0, 22.0 ],
					"text" : "receive output"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-42",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 360.0, 210.0, 92.0, 22.0 ],
					"text" : "prepend Output"
				}

			}
, 			{
				"box" : 				{
					"autosave" : 1,
					"bgmode" : 0,
					"border" : 0,
					"clickthrough" : 0,
					"id" : "obj-32",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 8,
					"offset" : [ 0.0, 0.0 ],
					"outlettype" : [ "signal", "signal", "", "list", "int", "", "", "" ],
					"patching_rect" : [ 75.0, 285.0, 309.0, 22.0 ],
					"save" : [ "#N", "vst~", "loaduniqueid", 0, 2, 2, "Black Box Analog Design HG-2", "@prefer", "VST3", ";" ],
					"saved_attribute_attributes" : 					{
						"valueof" : 						{
							"parameter_invisible" : 1,
							"parameter_longname" : "vst~[34]",
							"parameter_shortname" : "vst~[34]",
							"parameter_type" : 3
						}

					}
,
					"saved_object_attributes" : 					{
						"parameter_enable" : 1,
						"parameter_mappable" : 0,
						"prefer" : "VST3"
					}
,
					"snapshot" : 					{
						"filetype" : "C74Snapshot",
						"version" : 2,
						"minorversion" : 0,
						"name" : "snapshotlist",
						"origin" : "vst~",
						"type" : "list",
						"subtype" : "Undefined",
						"embed" : 1,
						"snapshot" : 						{
							"pluginname" : "Black Box Analog Design HG-2.vst3info",
							"plugindisplayname" : "Black Box Analog Design HG-2",
							"pluginsavedname" : "",
							"pluginsaveduniqueid" : 0,
							"version" : 1,
							"isbank" : 0,
							"isbase64" : 1,
							"blob" : "1158.VMjLgzGA...OVMEUy.Ea0cVZtMEcgQWY9vSRC8Vav8lak4Fc9LSNx3hPmACTwEjKtDjKXEEaMYzXt3BTtHWPUEldIcjKtPjKY4hKP4hbA4hKtPTPt3hKtDjKt3hKt3BLgISRx7jKB4hKq3BRt3xMCYlKtX2StHjKtLUVpI1c3LjKt3hcO4hKt3xJt3hKtbyPt3hK1QkdqoVXq3BRt3hKt3hKt3hKt3hKt3hKt3hKLUEV5kTaO81S371Jt3hKtbyPt3hK18jKt3hKAcmQiQUPt3hKt3hKt3hKt3hKt3hKt3hKt3hKTsFMFM1JpomZrcyPt3hK18jKt3hKq3hKt3BTqIlZUEySJAkdqrhKt3hK2LjKt3hcO4hKt3RPIckTzgyPl4hKt3hKt3hKt3hKt3hKt3hKt.ETukzUgkiciYjX2LjKt3hcO4hKt3xJt3hKtvDUXI2Zw7jKt3hKq3hKt3xMC4hKtX2St3hKtPTUrEVd3LjYt3hcO4hKt3xJt3hKtbyPt3hKPIEcioVXq3hKt3xMC4hKtX2St3hKtrhKt3hK2P0X5ETaOo0SXs1Jt3hKtbyPt3hK18jKt3hKOACUZMCNCYlKtX2StHjKtrhKH4hK2LjYt3BTSsVTsIlKt3hKt3hKt3hKt3hKt3hKt3hKt3BRTQlcMcjKt3hKt3hKt3hKt3hKt3hKt3hKt3hPEwVXwEjKt3hKt3hKt3hKt3hKt3hKt3hKtXFTzDzUX4hKt3BQt3hKt3hK77RRC8Vav8lak4Fc9vSREQVZzMzatQmbuwFakImOyjiLtHzYv.UbA4hKA4BVQwVSFMlKt.kKxETUgoWRG4hKD4RVt3BTtHWPt3hKDEjKt3hKA4hKt3hKt.SXxjjLO4hPt3xJtfjKtbyPl4hK18jKB4hKSkkZhcGNC4hKtX2St3hKtrhKt3hK2LjKt3hcTo2ZpE1JtfjKt3hKt3hKt3hKt3hKt3hKt3BSUgkdI01Su8DNushKt3hK2LjKt3hcO4hKt3RP2YzXTEjKt3hKt3hKt3hKt3hKt3hKt3hKt3BUqQiQishZ5oFa2LjKt3hcO4hKt3xJt3hKt.0ZhoVUw7jRPo2Jq3hKt3xMC4hKtX2St3hKtDTRWIEc3LjYt3hKt3hKt3hKt3hKt3hKt3hKPA0aIcUX4X2XFI1MC4hKtX2St3hKtrhKt3hKLQEVxsVLO4hKt3xJt3hKtbyPt3hK18jKt3hKDUEagkGNCYlKtX2St3hKtrhKt3hK2LjKt3BTRQ2XpE1Jt3hKtbyPt3hK18jKt3hKq3hKt3xMTMldA01SZ8DVqshKt3hK2LjKt3hcO4hKt3xSvPkVyfyPl4hK18jKB4hKq3BRt3xMCYlKt.0TqEUah4hKt3hKt3hKt3hKt3hKt3hKt3hKtfDUjYWSG4hKt3hKt3hKt3hKt3hKt3hKt3hKtHTQrEVbA4hKt3hKt3hKt3hKt3hKt3hKt3hKlAEMAcEVt3hKtPjKt3hKt3BOujTQjkFcC8lazI2arwVYx4COuX0TTMCTrU2Yo41TzEFck4C."
						}
,
						"snapshotlist" : 						{
							"current_snapshot" : 0,
							"entries" : [ 								{
									"filetype" : "C74Snapshot",
									"version" : 2,
									"minorversion" : 0,
									"name" : "Black Box Analog Design HG-2",
									"origin" : "Black Box Analog Design HG-2.vst3info",
									"type" : "VST3",
									"subtype" : "AudioEffect",
									"embed" : 0,
									"snapshot" : 									{
										"pluginname" : "Black Box Analog Design HG-2.vst3info",
										"plugindisplayname" : "Black Box Analog Design HG-2",
										"pluginsavedname" : "",
										"pluginsaveduniqueid" : 0,
										"version" : 1,
										"isbank" : 0,
										"isbase64" : 1,
										"blob" : "1158.VMjLgzGA...OVMEUy.Ea0cVZtMEcgQWY9vSRC8Vav8lak4Fc9LSNx3hPmACTwEjKtDjKXEEaMYzXt3BTtHWPUEldIcjKtPjKY4hKP4hbA4hKtPTPt3hKtDjKt3hKt3BLgISRx7jKB4hKq3BRt3xMCYlKtX2StHjKtLUVpI1c3LjKt3hcO4hKt3xJt3hKtbyPt3hK1QkdqoVXq3BRt3hKt3hKt3hKt3hKt3hKt3hKLUEV5kTaO81S371Jt3hKtbyPt3hK18jKt3hKAcmQiQUPt3hKt3hKt3hKt3hKt3hKt3hKt3hKTsFMFM1JpomZrcyPt3hK18jKt3hKq3hKt3BTqIlZUEySJAkdqrhKt3hK2LjKt3hcO4hKt3RPIckTzgyPl4hKt3hKt3hKt3hKt3hKt3hKt.ETukzUgkiciYjX2LjKt3hcO4hKt3xJt3hKtvDUXI2Zw7jKt3hKq3hKt3xMC4hKtX2St3hKtPTUrEVd3LjYt3hcO4hKt3xJt3hKtbyPt3hKPIEcioVXq3hKt3xMC4hKtX2St3hKtrhKt3hK2P0X5ETaOo0SXs1Jt3hKtbyPt3hK18jKt3hKOACUZMCNCYlKtX2StHjKtrhKH4hK2LjYt3BTSsVTsIlKt3hKt3hKt3hKt3hKt3hKt3hKt3BRTQlcMcjKt3hKt3hKt3hKt3hKt3hKt3hKt3hPEwVXwEjKt3hKt3hKt3hKt3hKt3hKt3hKtXFTzDzUX4hKt3BQt3hKt3hK77RRC8Vav8lak4Fc9vSREQVZzMzatQmbuwFakImOyjiLtHzYv.UbA4hKA4BVQwVSFMlKt.kKxETUgoWRG4hKD4RVt3BTtHWPt3hKDEjKt3hKA4hKt3hKt.SXxjjLO4hPt3xJtfjKtbyPl4hK18jKB4hKSkkZhcGNC4hKtX2St3hKtrhKt3hK2LjKt3hcTo2ZpE1JtfjKt3hKt3hKt3hKt3hKt3hKt3BSUgkdI01Su8DNushKt3hK2LjKt3hcO4hKt3RP2YzXTEjKt3hKt3hKt3hKt3hKt3hKt3hKt3BUqQiQishZ5oFa2LjKt3hcO4hKt3xJt3hKt.0ZhoVUw7jRPo2Jq3hKt3xMC4hKtX2St3hKtDTRWIEc3LjYt3hKt3hKt3hKt3hKt3hKt3hKPA0aIcUX4X2XFI1MC4hKtX2St3hKtrhKt3hKLQEVxsVLO4hKt3xJt3hKtbyPt3hK18jKt3hKDUEagkGNCYlKtX2St3hKtrhKt3hK2LjKt3BTRQ2XpE1Jt3hKtbyPt3hK18jKt3hKq3hKt3xMTMldA01SZ8DVqshKt3hK2LjKt3hcO4hKt3xSvPkVyfyPl4hK18jKB4hKq3BRt3xMCYlKt.0TqEUah4hKt3hKt3hKt3hKt3hKt3hKt3hKtfDUjYWSG4hKt3hKt3hKt3hKt3hKt3hKt3hKtHTQrEVbA4hKt3hKt3hKt3hKt3hKt3hKt3hKlAEMAcEVt3hKtPjKt3hKt3BOujTQjkFcC8lazI2arwVYx4COuX0TTMCTrU2Yo41TzEFck4C."
									}
,
									"fileref" : 									{
										"name" : "Black Box Analog Design HG-2",
										"filename" : "Black Box Analog Design HG-2.maxsnap",
										"filepath" : "~/Documents/Max 8/Snapshots",
										"filepos" : -1,
										"snapshotfileid" : "fe6431ff4d524ce50a1c8ff34976569a"
									}

								}
 ]
						}

					}
,
					"text" : "vst~ 2 2 \"Black Box Analog Design HG-2\" @prefer VST3",
					"varname" : "vst~[4]",
					"viewvisibility" : 0
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-22",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "multichannelsignal" ],
					"patching_rect" : [ 75.0, 330.0, 70.0, 22.0 ],
					"text" : "mc.pack~ 2"
				}

			}
, 			{
				"box" : 				{
					"autosave" : 1,
					"bgmode" : 0,
					"border" : 0,
					"clickthrough" : 0,
					"id" : "obj-21",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 8,
					"offset" : [ 0.0, 0.0 ],
					"outlettype" : [ "signal", "signal", "", "list", "int", "", "", "" ],
					"patching_rect" : [ 75.0, 180.0, 174.0, 22.0 ],
					"save" : [ "#N", "vst~", "loaduniqueid", 0, 2, 2, "TEOTE", "@prefer", "VST3", ";" ],
					"saved_attribute_attributes" : 					{
						"valueof" : 						{
							"parameter_invisible" : 1,
							"parameter_longname" : "vst~[48]",
							"parameter_shortname" : "vst~[48]",
							"parameter_type" : 3
						}

					}
,
					"saved_object_attributes" : 					{
						"parameter_enable" : 1,
						"parameter_mappable" : 0,
						"prefer" : "VST3"
					}
,
					"snapshot" : 					{
						"filetype" : "C74Snapshot",
						"version" : 2,
						"minorversion" : 0,
						"name" : "snapshotlist",
						"origin" : "vst~",
						"type" : "list",
						"subtype" : "Undefined",
						"embed" : 1,
						"snapshot" : 						{
							"pluginname" : "TEOTE.vst3info",
							"plugindisplayname" : "TEOTE",
							"pluginsavedname" : "",
							"pluginsaveduniqueid" : 0,
							"version" : 1,
							"isbank" : 0,
							"isbase64" : 1,
							"blob" : "1369.VMjLg.UA...OVMEUy.Ea0cVZtMEcgQWY9vSRC8Vav8lak4Fc9jyMx3xYA0lX40jPD4hKtzjKtvjKyPSUyg0b4I1TCQDQ4fzStbDRAwzYDw1YP4hTBMTdDgkQYgWXBc1QVkDTrwDaIMicDIUPMQkXwjibywlaWgTRGcjYq3BU1UlKybUPyo2ZmclQv4lYNAmaqojTgUCVOk0aXMmT0nFQEIVdhEkV0YSXqDCNwL1Si0VdlQjPQElLJAiUzbmb0nmUv4jLtn1QBUSUjMWRvDiUn81Tw4FdzcDS1s1YNMWUMUTZBokQvPlRUEUctHDdIY1azLFZxL0JxPybhAUcmsVTKMUXrUiT1YyULITU4jGaDsjX0IUTxDyYvc0ZI81TvfUXPgVdwAET2PCRzQFTgwjSsE1PIMEbEUUdzAELrQ0XiwFbpE2UIkUXto0MDgUNgUDLTkjaQIUbpEUTVEWZNIVcvjSa1QzUOETdD4hVyT0Tz4RckIkaqH1QrUTdtcTcQUSQ0zjZrE2UpMyM3bFQW4VYpMCZsQTRzo2aPglLIcjThkUY2Q1MFg1TisBYzIzUSkyMCMEZxIWU5ElbOwTMDoFUVkmKzYWP5IFQQM2PKgVYRo1cOk2X2j2cHEDNHUzXIsxMtEFRz0DVr8VRngib1MyPsIEdGIEY4QlPHI2X1IVTugmahE0a34lXQ8FdtIVTugmahE0a34lXQ8FdK8jKRcCcsEyTx8zU2kUazvDVzj0QDszSx.EVzPySKYEYmk2YqcESOYEYIUFMpoTQyPGRxT2L4HjL4HVX3M2PsEFc4jFTBsFVlglKG4FRyzjcyLUTRwzZybFUhQiTpgGZLIicEYmVwXWXJYULuUkK1j1R1TjcYU2YqHkPxgGNWkScqo1MWIkPtfyJQoFZqjEMzYTdz8VTgkDbvA2JwTjMRYmdxnFRwXCZtAEVko2JiQ2S3EWVtnTLvsVdFQ2Qq4xJzDjcPcURBsxYtrVPNISV3LWLYgiPTczQZAyXEgWVPA0c2QyQq3Rc3zDSsUUXvAmasYTai4xZpUlSRQkSq4RVwnkZyDSaDcjT2ImLYcTVWMlVzvjMhISa5QibRE0M3cmZzLiRlEiajgidnEDclgVZ4M2UgkScqPSP4TkaXY1R2vTQCUCZL8FV1QyP34zTk8zUEMiMKQGaXAGNmsVVjEWdXACbtr1SuYWbOImZyfiPHQ1bXUmT3gFbxX1bJwzMpkjc2bmKSojMmMCa0UjRSIlLE4FVzkWRoMiUv3RNynFbJoVYRclMz4RZoEVaIcTRxLSct8DMuIDdyYSaXcCctwlUqITUtUCLpAmV5IkLzjkKvkEQgozY0jDYU0zb2n1aXQSLJAiXZQWQtTSLqLkQwT0bLcUQXoUVTcUTqkDLTkzZtk0Ulc2c3byJz3VZ0LFL0gzQKICbFkkZ1LScYcyUqnWLwcCcxT2aLoUcxUmRZoDLRkUch4hZnklRKgzSZImbCEFUkQTRzM0RoUjVREEN2DDMxf1a34VLxcjPoMVU2QkMmoTLyLWX1bTQGYTdvM2awUFRCklSQI0M0b1R4UURwzzarMlUnUmZpgEaxsjclcyZoYFMN8lQ0HVQgU0PSYkRsE2LnE0MJk0LCAUbDczPSkzQE0zLv0zaTMULE4FVzk2Ro4Tdv0TdQMUVqPkS4A2PHEjXjA0bzjyXQkyXj0TLokUVSACSmkFZgImPH8jUDIzPnAkbGQFVQkybt0zYL4Td2gyQnIWRHQ1aHoVQtXVc4bGLzHCTxXSYEY1JPsBLw4BZmsBOujzPu0Fbu4VYtQmO77hUSQ0LPwVcmklaSQWXzUlO.."
						}
,
						"snapshotlist" : 						{
							"current_snapshot" : 0,
							"entries" : [ 								{
									"filetype" : "C74Snapshot",
									"version" : 2,
									"minorversion" : 0,
									"name" : "TEOTE",
									"origin" : "TEOTE.vst3info",
									"type" : "VST3",
									"subtype" : "MidiEffect",
									"embed" : 0,
									"snapshot" : 									{
										"pluginname" : "TEOTE.vst3info",
										"plugindisplayname" : "TEOTE",
										"pluginsavedname" : "",
										"pluginsaveduniqueid" : 0,
										"version" : 1,
										"isbank" : 0,
										"isbase64" : 1,
										"blob" : "1369.VMjLg.UA...OVMEUy.Ea0cVZtMEcgQWY9vSRC8Vav8lak4Fc9jyMx3xYA0lX40jPD4hKtzjKtvjKyPSUyg0b4I1TCQDQ4fzStbDRAwzYDw1YP4hTBMTdDgkQYgWXBc1QVkDTrwDaIMicDIUPMQkXwjibywlaWgTRGcjYq3BU1UlKybUPyo2ZmclQv4lYNAmaqojTgUCVOk0aXMmT0nFQEIVdhEkV0YSXqDCNwL1Si0VdlQjPQElLJAiUzbmb0nmUv4jLtn1QBUSUjMWRvDiUn81Tw4FdzcDS1s1YNMWUMUTZBokQvPlRUEUctHDdIY1azLFZxL0JxPybhAUcmsVTKMUXrUiT1YyULITU4jGaDsjX0IUTxDyYvc0ZI81TvfUXPgVdwAET2PCRzQFTgwjSsE1PIMEbEUUdzAELrQ0XiwFbpE2UIkUXto0MDgUNgUDLTkjaQIUbpEUTVEWZNIVcvjSa1QzUOETdD4hVyT0Tz4RckIkaqH1QrUTdtcTcQUSQ0zjZrE2UpMyM3bFQW4VYpMCZsQTRzo2aPglLIcjThkUY2Q1MFg1TisBYzIzUSkyMCMEZxIWU5ElbOwTMDoFUVkmKzYWP5IFQQM2PKgVYRo1cOk2X2j2cHEDNHUzXIsxMtEFRz0DVr8VRngib1MyPsIEdGIEY4QlPHI2X1IVTugmahE0a34lXQ8FdtIVTugmahE0a34lXQ8FdK8jKRcCcsEyTx8zU2kUazvDVzj0QDszSx.EVzPySKYEYmk2YqcESOYEYIUFMpoTQyPGRxT2L4HjL4HVX3M2PsEFc4jFTBsFVlglKG4FRyzjcyLUTRwzZybFUhQiTpgGZLIicEYmVwXWXJYULuUkK1j1R1TjcYU2YqHkPxgGNWkScqo1MWIkPtfyJQoFZqjEMzYTdz8VTgkDbvA2JwTjMRYmdxnFRwXCZtAEVko2JiQ2S3EWVtnTLvsVdFQ2Qq4xJzDjcPcURBsxYtrVPNISV3LWLYgiPTczQZAyXEgWVPA0c2QyQq3Rc3zDSsUUXvAmasYTai4xZpUlSRQkSq4RVwnkZyDSaDcjT2ImLYcTVWMlVzvjMhISa5QibRE0M3cmZzLiRlEiajgidnEDclgVZ4M2UgkScqPSP4TkaXY1R2vTQCUCZL8FV1QyP34zTk8zUEMiMKQGaXAGNmsVVjEWdXACbtr1SuYWbOImZyfiPHQ1bXUmT3gFbxX1bJwzMpkjc2bmKSojMmMCa0UjRSIlLE4FVzkWRoMiUv3RNynFbJoVYRclMz4RZoEVaIcTRxLSct8DMuIDdyYSaXcCctwlUqITUtUCLpAmV5IkLzjkKvkEQgozY0jDYU0zb2n1aXQSLJAiXZQWQtTSLqLkQwT0bLcUQXoUVTcUTqkDLTkzZtk0Ulc2c3byJz3VZ0LFL0gzQKICbFkkZ1LScYcyUqnWLwcCcxT2aLoUcxUmRZoDLRkUch4hZnklRKgzSZImbCEFUkQTRzM0RoUjVREEN2DDMxf1a34VLxcjPoMVU2QkMmoTLyLWX1bTQGYTdvM2awUFRCklSQI0M0b1R4UURwzzarMlUnUmZpgEaxsjclcyZoYFMN8lQ0HVQgU0PSYkRsE2LnE0MJk0LCAUbDczPSkzQE0zLv0zaTMULE4FVzk2Ro4Tdv0TdQMUVqPkS4A2PHEjXjA0bzjyXQkyXj0TLokUVSACSmkFZgImPH8jUDIzPnAkbGQFVQkybt0zYL4Td2gyQnIWRHQ1aHoVQtXVc4bGLzHCTxXSYEY1JPsBLw4BZmsBOujzPu0Fbu4VYtQmO77hUSQ0LPwVcmklaSQWXzUlO.."
									}
,
									"fileref" : 									{
										"name" : "TEOTE",
										"filename" : "TEOTE.maxsnap",
										"filepath" : "~/Documents/Max 8/Snapshots",
										"filepos" : -1,
										"snapshotfileid" : "9912d0e11ab47253b322b0a619ec45f5"
									}

								}
 ]
						}

					}
,
					"text" : "vst~ 2 2 TEOTE @prefer VST3",
					"varname" : "vst~[3]",
					"viewvisibility" : 0
				}

			}
, 			{
				"box" : 				{
					"comment" : "Dry",
					"id" : "obj-31",
					"index" : 0,
					"maxclass" : "outlet",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 75.0, 810.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-30",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 840.0, 480.0, 32.0, 22.0 ],
					"text" : "/ 1.5"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-29",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 435.0, 609.0, 103.0, 22.0 ],
					"text" : "scale 0.1 10. 0. 1."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-28",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 435.0, 503.0, 103.0, 22.0 ],
					"text" : "scale 0. 100. 0. 1."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-6",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 180.0, 570.0, 103.0, 22.0 ],
					"text" : "scale 0. 100. 0. 1."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-5",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 180.0, 465.0, 110.0, 22.0 ],
					"text" : "scale 0.1 100. 0. 1."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-4",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 180.0, 354.0, 103.0, 22.0 ],
					"text" : "scale 0. 500. 0. 1."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-62",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "multichannelsignal" ],
					"patching_rect" : [ 1185.0, 735.0, 40.0, 22.0 ],
					"text" : "mc.*~"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-61",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 1200.0, 465.0, 31.0, 22.0 ],
					"text" : "sig~"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-60",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1200.0, 435.0, 39.0, 22.0 ],
					"text" : "dbtoa"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-54",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 885.0, 555.0, 31.0, 22.0 ],
					"text" : "sig~"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-53",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 720.0, 555.0, 73.0, 22.0 ],
					"text" : "expr 1. - $f1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-47",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 885.0, 480.0, 31.0, 22.0 ],
					"text" : "sig~"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-45",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 1020.0, 570.0, 29.5, 22.0 ],
					"text" : "*~"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-46",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 975.0, 570.0, 29.5, 22.0 ],
					"text" : "*~"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-44",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 1020.0, 525.0, 29.5, 22.0 ],
					"text" : "*~"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-43",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 975.0, 525.0, 29.5, 22.0 ],
					"text" : "*~"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-39",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 720.0, 480.0, 103.0, 22.0 ],
					"text" : "scale 100. 0. 0. 1."
				}

			}
, 			{
				"box" : 				{
					"comment" : "Wet Reverb Signal",
					"id" : "obj-38",
					"index" : 0,
					"maxclass" : "outlet",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1185.0, 810.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-37",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1200.0, 405.0, 107.0, 22.0 ],
					"text" : "scale 0. 100. 0. -3."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-27",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "multichannelsignal" ],
					"patching_rect" : [ 1185.0, 699.0, 70.0, 22.0 ],
					"text" : "mc.pack~ 2"
				}

			}
, 			{
				"box" : 				{
					"autosave" : 1,
					"bgmode" : 0,
					"border" : 0,
					"clickthrough" : 0,
					"id" : "obj-26",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 8,
					"offset" : [ 0.0, 0.0 ],
					"outlettype" : [ "signal", "signal", "", "list", "int", "", "", "" ],
					"patching_rect" : [ 1020.0, 615.0, 185.0, 22.0 ],
					"save" : [ "#N", "vst~", "loaduniqueid", 0, 2, 2, "Pro-Q 3", "@prefer", "VST3", ";" ],
					"saved_attribute_attributes" : 					{
						"valueof" : 						{
							"parameter_invisible" : 1,
							"parameter_longname" : "vst~[3]",
							"parameter_shortname" : "vst~[2]",
							"parameter_type" : 3
						}

					}
,
					"saved_object_attributes" : 					{
						"parameter_enable" : 1,
						"parameter_mappable" : 0,
						"prefer" : "VST3"
					}
,
					"snapshot" : 					{
						"filetype" : "C74Snapshot",
						"version" : 2,
						"minorversion" : 0,
						"name" : "snapshotlist",
						"origin" : "vst~",
						"type" : "list",
						"subtype" : "Undefined",
						"embed" : 1,
						"snapshot" : 						{
							"pluginname" : "Pro-Q 3.auinfo",
							"plugindisplayname" : "Pro-Q 3",
							"pluginsavedname" : "",
							"pluginsaveduniqueid" : 1179726704,
							"version" : 1,
							"isbank" : 0,
							"isbase64" : 1,
							"blob" : "1688.hAGaoMGcv.i0AHv.DTfAGfPBJr.CWMWchQWdvUFWsEla0YVXiQWcxUlbeAAEFElXFkFazUlbPwVcmklaSQWXzUFUtEVakQEc4AWYWYWYxMWZu4lDFE0LvIgQgIlQOEQAjajQBMU.....lE.......9C...3O3oI0.AcEFBL........f+....9C...vO.....A...9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3O...f+....................................9C........f+B....D...DP...f.A...AD..............9C....P..........................................................................................................................................fQQMCbC....7.....QkYVX0wFcfLUYzQWZtc1+++++A....j.....Tx8VKQABJxjR.....CU2TVE..........eAwCDUlYgUGazAxTkQGco41YRDVcsYFD...B.TA.c.fJ.DD.FAvR.LE.XAPWFTjAWY.W........BD..........M...................F3E"
						}
,
						"snapshotlist" : 						{
							"current_snapshot" : 0,
							"entries" : [ 								{
									"filetype" : "C74Snapshot",
									"version" : 2,
									"minorversion" : 0,
									"name" : "Pro-Q 3",
									"origin" : "Pro-Q 3.auinfo",
									"type" : "AudioUnit",
									"subtype" : "MidiEffect",
									"embed" : 0,
									"snapshot" : 									{
										"pluginname" : "Pro-Q 3.auinfo",
										"plugindisplayname" : "Pro-Q 3",
										"pluginsavedname" : "",
										"pluginsaveduniqueid" : 1179726704,
										"version" : 1,
										"isbank" : 0,
										"isbase64" : 1,
										"blob" : "1688.hAGaoMGcv.i0AHv.DTfAGfPBJr.CWMWchQWdvUFWsEla0YVXiQWcxUlbeAAEFElXFkFazUlbPwVcmklaSQWXzUFUtEVakQEc4AWYWYWYxMWZu4lDFE0LvIgQgIlQOEQAjajQBMU.....lE.......9C...3O3oI0.AcEFBL........f+....9C...vO.....A...9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3OZO2GAA.............f+....9C...vO.........9C....P...f+..............f+n8beDD..............9C...3O....+.........3O.....A...9C..............9i1y8QP..............3O...f+....7C........f+.....D...3O..............3O...f+....................................9C........f+B....D...DP...f.A...AD..............9C....P..........................................................................................................................................fQQMCbC....7.....QkYVX0wFcfLUYzQWZtc1+++++A....j.....Tx8VKQABJxjR.....CU2TVE..........eAwCDUlYgUGazAxTkQGco41YRDVcsYFD...B.TA.c.fJ.DD.FAvR.LE.XAPWFTjAWY.W........BD..........M...................F3E"
									}
,
									"fileref" : 									{
										"name" : "Pro-Q 3",
										"filename" : "Pro-Q 3.maxsnap",
										"filepath" : "~/Documents/Max 8/Snapshots",
										"filepos" : -1,
										"snapshotfileid" : "0234981b3cef02f74d267b4cf6517d55"
									}

								}
 ]
						}

					}
,
					"text" : "vst~ 2 2 \"Pro-Q 3\" @prefer VST3",
					"varname" : "vst~[2]",
					"viewvisibility" : 0
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-25",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 435.0, 585.0, 117.0, 22.0 ],
					"text" : "scale 0. 100. 0.1 3.5"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-24",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 435.0, 480.0, 117.0, 22.0 ],
					"text" : "scale 0. 100. 0. 100."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-23",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 435.0, 405.0, 137.0, 22.0 ],
					"text" : "scale 0. 100. 0.337 0.71"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-20",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 435.0, 330.0, 110.0, 22.0 ],
					"text" : "scale 0. 100. 0.3 0."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-19",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 180.0, 546.0, 117.0, 22.0 ],
					"text" : "scale 0. 100. 18. 91."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-18",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 180.0, 441.0, 103.0, 22.0 ],
					"text" : "scale 0. 100. 1. 9."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-17",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 180.0, 330.0, 110.0, 22.0 ],
					"text" : "scale 0. 100. 23. 2."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-16",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 435.0, 645.0, 105.0, 22.0 ],
					"text" : "prepend ModRate"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-15",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 435.0, 540.0, 89.0, 22.0 ],
					"text" : "prepend Attack"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-14",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 435.0, 435.0, 90.0, 22.0 ],
					"text" : "prepend Decay"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-13",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 435.0, 360.0, 105.0, 22.0 ],
					"text" : "prepend PreDelay"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-12",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 180.0, 495.0, 88.0, 22.0 ],
					"text" : "prepend decay"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-11",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 180.0, 600.0, 135.0, 22.0 ],
					"text" : "prepend earlyLateMix"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-10",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 180.0, 390.0, 102.0, 22.0 ],
					"text" : "prepend predelay"
				}

			}
, 			{
				"box" : 				{
					"comment" : "Amount",
					"id" : "obj-9",
					"index" : 0,
					"maxclass" : "inlet",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1200.0, 15.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"comment" : "Kind (Room <-> Vintage)",
					"id" : "obj-8",
					"index" : 0,
					"maxclass" : "inlet",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 720.0, 15.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-7",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "signal", "signal" ],
					"patching_rect" : [ 75.0, 75.0, 84.0, 22.0 ],
					"text" : "mc.unpack~ 2"
				}

			}
, 			{
				"box" : 				{
					"autosave" : 1,
					"bgmode" : 0,
					"border" : 0,
					"clickthrough" : 0,
					"id" : "obj-3",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 8,
					"offset" : [ 0.0, 0.0 ],
					"outlettype" : [ "signal", "signal", "", "list", "int", "", "", "" ],
					"patching_rect" : [ 435.0, 690.0, 241.0, 22.0 ],
					"save" : [ "#N", "vst~", "loaduniqueid", 0, 2, 2, "ValhallaVintageVerb", "@prefer", "VST3", ";" ],
					"saved_attribute_attributes" : 					{
						"valueof" : 						{
							"parameter_invisible" : 1,
							"parameter_longname" : "vst~[5]",
							"parameter_shortname" : "vst~",
							"parameter_type" : 3
						}

					}
,
					"saved_object_attributes" : 					{
						"parameter_enable" : 1,
						"parameter_mappable" : 0,
						"prefer" : "VST3"
					}
,
					"snapshot" : 					{
						"filetype" : "C74Snapshot",
						"version" : 2,
						"minorversion" : 0,
						"name" : "snapshotlist",
						"origin" : "vst~",
						"type" : "list",
						"subtype" : "Undefined",
						"embed" : 1,
						"snapshot" : 						{
							"pluginname" : "ValhallaVintageVerb.vst3info",
							"plugindisplayname" : "ValhallaVintageVerb",
							"pluginsavedname" : "",
							"pluginsaveduniqueid" : 0,
							"version" : 1,
							"isbank" : 0,
							"isbase64" : 1,
							"blob" : "1149.VMjLgPGA...OVMEUy.Ea0cVZtMEcgQWY9vSRC8Vav8lak4Fc9fCL23hUMczXWEjKt3hYt3hKt.kKt3hKt3BS5gEcyQjKtvjcCYTR5AkaA4hKtfjYisVUwvjKHYlKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKBIVaUMTRSgDdH4hKtXWdOMCLFElYXcUV30zUZUGMV8DZDk1R1gjPHsFMwfUcQYkVzMlUOgFUEUkQvHjSncSZOYlcoU0Y2YjVmcmQgcVVUoEcQcEVsUEaUsVRsgkYtbTXvLlUZQWVUkEdMckV0QiUOgFRosDdyHDSn4hPhgWUwH1ZQ01TmAiUYgCRBE0ZYYEVvbmQiglKRM0amc0SnQTZKYGRBgDTIcUVDUkQgc1ZW8DZtj1R44xPLYmKCwjcDMESzfzPLQCRS4DZtHTTq0jUXQCLogjcyfGS4I1PLYmKCwzcHkGSzHVdMECVSwDZtfGUu81UYgCRRwDctjFRlQDQioWQwfUbvjFR1MiPLglKnA0YMIiXMU0QgoGLogjcyfWS34xPLYmKCwDdlkVS24RZLgmZS0DZtfFTm0jLhgENrM1ZIc0Sn4RZKkmZS0jctLDS1QzPLICRC4zLLkVS2gjPHgzZwjkaMUjVqcGaYgCRBwDcTMUS54xPLYmKowjctjFSxPTZMYGVogjYlQkVscFaQgWUVIFNHIDSzA0TNYmKCwjctLDSzPUdLEiXC0TdHkFRlQEUXg2cVQFQqwVVrUkLh8FNrEFNHIESz4RZHYlcTgkdUYTTukEaYASSWoUczX0SnQTZKYGRBgTS3XTVRUjQisFLogjcyHDSn4hTSUWTFE0ZAczXtASZHY2L3wjLpMkSzn1TNQCUowTdDkVS3Y1PMglKBI0aiYjVCU0QigCRBwDcXMjS1o1TNQiZS4jdHkWSxn1TMoGQogjY1oWXxzDUioGLogjcyfFS2I1TNQiZS4DMPkWSv.UdMQCQ4wDZtfGT0cWLggGL5ElZUY0Sn4RZKECVo0TLXkVSwXVZMACSC0zLlMESwfjPHIUUrM1ZI0FVMgiQYsFLogjcyfWSzPTZMECVo0zLXMUS4A0PNMCQo0DZtHUXuc1QSUWSwnENHIDSn4hTi81XUokZQcjV3fjTNkGUogjYTckVHUkUZ01YFMFNHITS4QUZHU2LC4hKt3hKt3hKt3hKlIUUMQUTPkzUZESQFM1ZQQEV5UjQtDDQlAEMAcEV40zQtDDQ14hK5EjKt3hKt3hKt3hRUACTEEzZh8VVWgkdUYTTmE0UXwyKIMzasA2atUlaz4COuX0TTMCTrU2Yo41TzEFck4C."
						}
,
						"snapshotlist" : 						{
							"current_snapshot" : 0,
							"entries" : [ 								{
									"filetype" : "C74Snapshot",
									"version" : 2,
									"minorversion" : 0,
									"name" : "ValhallaVintageVerb",
									"origin" : "ValhallaVintageVerb.vst3info",
									"type" : "VST3",
									"subtype" : "AudioEffect",
									"embed" : 0,
									"snapshot" : 									{
										"pluginname" : "ValhallaVintageVerb.vst3info",
										"plugindisplayname" : "ValhallaVintageVerb",
										"pluginsavedname" : "",
										"pluginsaveduniqueid" : 0,
										"version" : 1,
										"isbank" : 0,
										"isbase64" : 1,
										"blob" : "1149.VMjLgPGA...OVMEUy.Ea0cVZtMEcgQWY9vSRC8Vav8lak4Fc9fCL23hUMczXWEjKt3hYt3hKt.kKt3hKt3BS5gEcyQjKtvjcCYTR5AkaA4hKtfjYisVUwvjKHYlKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKBIVaUMTRSgDdH4hKtXWdOMCLFElYXcUV30zUZUGMV8DZDk1R1gjPHsFMwfUcQYkVzMlUOgFUEUkQvHjSncSZOYlcoU0Y2YjVmcmQgcVVUoEcQcEVsUEaUsVRsgkYtbTXvLlUZQWVUkEdMckV0QiUOgFRosDdyHDSn4hPhgWUwH1ZQ01TmAiUYgCRBE0ZYYEVvbmQiglKRM0amc0SnQTZKYGRBgDTIcUVDUkQgc1ZW8DZtj1R44xPLYmKCwjcDMESzfzPLQCRS4DZtHTTq0jUXQCLogjcyfGS4I1PLYmKCwzcHkGSzHVdMECVSwDZtfGUu81UYgCRRwDctjFRlQDQioWQwfUbvjFR1MiPLglKnA0YMIiXMU0QgoGLogjcyfWS34xPLYmKCwDdlkVS24RZLgmZS0DZtfFTm0jLhgENrM1ZIc0Sn4RZKkmZS0jctLDS1QzPLICRC4zLLkVS2gjPHgzZwjkaMUjVqcGaYgCRBwDcTMUS54xPLYmKowjctjFSxPTZMYGVogjYlQkVscFaQgWUVIFNHIDSzA0TNYmKCwjctLDSzPUdLEiXC0TdHkFRlQEUXg2cVQFQqwVVrUkLh8FNrEFNHIESz4RZHYlcTgkdUYTTukEaYASSWoUczX0SnQTZKYGRBgTS3XTVRUjQisFLogjcyHDSn4hTSUWTFE0ZAczXtASZHY2L3wjLpMkSzn1TNQCUowTdDkVS3Y1PMglKBI0aiYjVCU0QigCRBwDcXMjS1o1TNQiZS4jdHkWSxn1TMoGQogjY1oWXxzDUioGLogjcyfFS2I1TNQiZS4DMPkWSv.UdMQCQ4wDZtfGT0cWLggGL5ElZUY0Sn4RZKECVo0TLXkVSwXVZMACSC0zLlMESwfjPHIUUrM1ZI0FVMgiQYsFLogjcyfWSzPTZMECVo0zLXMUS4A0PNMCQo0DZtHUXuc1QSUWSwnENHIDSn4hTi81XUokZQcjV3fjTNkGUogjYTckVHUkUZ01YFMFNHITS4QUZHU2LC4hKt3hKt3hKt3hKlIUUMQUTPkzUZESQFM1ZQQEV5UjQtDDQlAEMAcEV40zQtDDQ14hK5EjKt3hKt3hKt3hRUACTEEzZh8VVWgkdUYTTmE0UXwyKIMzasA2atUlaz4COuX0TTMCTrU2Yo41TzEFck4C."
									}
,
									"fileref" : 									{
										"name" : "ValhallaVintageVerb",
										"filename" : "ValhallaVintageVerb.maxsnap",
										"filepath" : "~/Documents/Max 8/Snapshots",
										"filepos" : -1,
										"snapshotfileid" : "e3f4f5d5312ba9ef68710239ec884b4d"
									}

								}
 ]
						}

					}
,
					"text" : "vst~ 2 2 ValhallaVintageVerb @prefer VST3",
					"varname" : "vst~[1]",
					"viewvisibility" : 0
				}

			}
, 			{
				"box" : 				{
					"comment" : "Signal",
					"id" : "obj-2",
					"index" : 0,
					"maxclass" : "inlet",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 75.0, 15.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"autosave" : 1,
					"bgmode" : 0,
					"border" : 0,
					"clickthrough" : 0,
					"id" : "obj-1",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 8,
					"offset" : [ 0.0, 0.0 ],
					"outlettype" : [ "signal", "signal", "", "list", "int", "", "", "" ],
					"patching_rect" : [ 180.0, 651.0, 208.0, 22.0 ],
					"save" : [ "#N", "vst~", "loaduniqueid", 0, 2, 2, "ValhallaRoom", "@prefer", "VST3", ";" ],
					"saved_attribute_attributes" : 					{
						"valueof" : 						{
							"parameter_invisible" : 1,
							"parameter_longname" : "vst~[4]",
							"parameter_shortname" : "vst~",
							"parameter_type" : 3
						}

					}
,
					"saved_object_attributes" : 					{
						"parameter_enable" : 1,
						"parameter_mappable" : 0,
						"prefer" : "VST3"
					}
,
					"snapshot" : 					{
						"filetype" : "C74Snapshot",
						"version" : 2,
						"minorversion" : 0,
						"name" : "snapshotlist",
						"origin" : "vst~",
						"type" : "list",
						"subtype" : "Undefined",
						"embed" : 1,
						"snapshot" : 						{
							"pluginname" : "ValhallaRoom.vst3info",
							"plugindisplayname" : "ValhallaRoom",
							"pluginsavedname" : "",
							"pluginsaveduniqueid" : 0,
							"version" : 1,
							"isbank" : 0,
							"isbase64" : 1,
							"blob" : "1337.VMjLg.SA...OVMEUy.Ea0cVZtMEcgQWY9vSRC8Vav8lak4Fc9jCM33hUMczXWEjKt3hYt3hKt.kKt3hKt3BS5gEcyQjKtvjKsYTR5AkaA4hKtfjYTASUWElKDYVPE4hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKCAkYUMTRSgzJJ4hKtXWdOMCLFElYXcUV30zUZUGMV8DZDk1R1gjPHsFMwfUcQYkVzMlUOgFUEUkQvHjSncSZOYlcoU0Y2YjVmcmQgcVRvDVcvXDR1cmUi01ZrElUUwlX4sVLgQGLogzcyfVSzQUZHYlKsI1ZMcUV5QCUXMWUV8DZtrlXq0zUYoWPnkUcIcDRE0zQh8VRWgkbAgFS1gTZLMGQCwzbLMESn4hTg81YW8DZDk1R1gjPHYWRWkkZUYTXms1UOglKosjcPkVS14xPLYmKCwjclMkS54RZMQiXogjYPYUVoUjUjgCRBwDctLDSz3xPLQiKCwDMHkFSxPzTMECV4wDMHIDRHsVLY4VSTMldvjFR2MiPLglKRk0YIcTXzbGUXoWUVM0amc0Sn4RZKcmYCwjctLDS14RdMcGUowDLTkWS5gjPHIWQFM1ZMUkV0TkUOglKosjdLMkSzn1TNQiZ40TLDMUSyPzPMgGRBgjbEYzXq0jZhUWSxHFNHIDSzg0PMQiZS4DMpkWSwPzTMMCQC0DdDkFRlYmUXoWUVMUcQwFUmE0UYgCRBwDctLkS5o1PMQCTS4zcLkFS34xPMYGUo0DZtHTXmE0UY0DNFkEQUYjX5clUOglKosjcHIDRRE0ZPcVSxHVSUcTX5slQhI2ZW8DZtj1RwfUZMECVo0TLlkVSvvzPMMiYSwTLHIDRREUQVUWVWkEdvjFR1MiPLomZC0DMPMkS5YVZLkmYSwTdPkGSyfjPHIUTEI0aiYjVMU0Qgo2ZFIlbqc0Sn4RZKcmX40jLhkWSxXVZLYmYowDLTkWSxfjPHIUTEI0aiYjVXgCaisVRW8DZtj1R3o1TNkGRC4zLXkGSwfzPLICUC4zcHIDRqUDahI2ZxP0aucUV3fjPLQmK40zLtjWSy3RdMECRC0TdPMDS1QUdMglKRk0YIcTXzzjZhUWSxHFNHIESz4RZHYFUVgEd2YEYMgiQYIUQFM1ZvjFR1MiTLQCQS4zcpMESzfTZMICQ40jLTMjSn4hTYcVRGEFMvnWXpEEUYYWTGoENHIDSz4RZHYFUVgEd2YEYSUEagoFLogjcyfVS34xPLYmKCwjcPkWSwXVdLICQo0DZtHTVukEaYASSWoUczX0SnQTZKYGRBgjdqcjXqASZHY2LBwzLLkGS4wTdLkGUC4zcXMjSw3RZLglKRE1amczT00TLZgCRBwDZtH0XuMVUZoVTGoENHgWS4QUZHYFUWoERUYkVsclQigCRB0TLtjFR0MyPt3hKt3hKt3hKt3hYRUUSTEETIckVwTjQisVTTgkdEYjKAQjYPQSPWgUdMcjKAQjct3hdA4hKt3hKt3hKtnTUv.UQAslXuk0UXoWUFE0YQcEV77RRC8Vav8lak4Fc9vyKVMEUy.Ea0cVZtMEcgQWY9.."
						}
,
						"snapshotlist" : 						{
							"current_snapshot" : 0,
							"entries" : [ 								{
									"filetype" : "C74Snapshot",
									"version" : 2,
									"minorversion" : 0,
									"name" : "ValhallaRoom",
									"origin" : "ValhallaRoom.vst3info",
									"type" : "VST3",
									"subtype" : "AudioEffect",
									"embed" : 0,
									"snapshot" : 									{
										"pluginname" : "ValhallaRoom.vst3info",
										"plugindisplayname" : "ValhallaRoom",
										"pluginsavedname" : "",
										"pluginsaveduniqueid" : 0,
										"version" : 1,
										"isbank" : 0,
										"isbase64" : 1,
										"blob" : "1337.VMjLg.SA...OVMEUy.Ea0cVZtMEcgQWY9vSRC8Vav8lak4Fc9jCM33hUMczXWEjKt3hYt3hKt.kKt3hKt3BS5gEcyQjKtvjKsYTR5AkaA4hKtfjYTASUWElKDYVPE4hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKt3hKCAkYUMTRSgzJJ4hKtXWdOMCLFElYXcUV30zUZUGMV8DZDk1R1gjPHsFMwfUcQYkVzMlUOgFUEUkQvHjSncSZOYlcoU0Y2YjVmcmQgcVRvDVcvXDR1cmUi01ZrElUUwlX4sVLgQGLogzcyfVSzQUZHYlKsI1ZMcUV5QCUXMWUV8DZtrlXq0zUYoWPnkUcIcDRE0zQh8VRWgkbAgFS1gTZLMGQCwzbLMESn4hTg81YW8DZDk1R1gjPHYWRWkkZUYTXms1UOglKosjcPkVS14xPLYmKCwjclMkS54RZMQiXogjYPYUVoUjUjgCRBwDctLDSz3xPLQiKCwDMHkFSxPzTMECV4wDMHIDRHsVLY4VSTMldvjFR2MiPLglKRk0YIcTXzbGUXoWUVM0amc0Sn4RZKcmYCwjctLDS14RdMcGUowDLTkWS5gjPHIWQFM1ZMUkV0TkUOglKosjdLMkSzn1TNQiZ40TLDMUSyPzPMgGRBgjbEYzXq0jZhUWSxHFNHIDSzg0PMQiZS4DMpkWSwPzTMMCQC0DdDkFRlYmUXoWUVMUcQwFUmE0UYgCRBwDctLkS5o1PMQCTS4zcLkFS34xPMYGUo0DZtHTXmE0UY0DNFkEQUYjX5clUOglKosjcHIDRRE0ZPcVSxHVSUcTX5slQhI2ZW8DZtj1RwfUZMECVo0TLlkVSvvzPMMiYSwTLHIDRREUQVUWVWkEdvjFR1MiPLomZC0DMPMkS5YVZLkmYSwTdPkGSyfjPHIUTEI0aiYjVMU0Qgo2ZFIlbqc0Sn4RZKcmX40jLhkWSxXVZLYmYowDLTkWSxfjPHIUTEI0aiYjVXgCaisVRW8DZtj1R3o1TNkGRC4zLXkGSwfzPLICUC4zcHIDRqUDahI2ZxP0aucUV3fjPLQmK40zLtjWSy3RdMECRC0TdPMDS1QUdMglKRk0YIcTXzzjZhUWSxHFNHIESz4RZHYFUVgEd2YEYMgiQYIUQFM1ZvjFR1MiTLQCQS4zcpMESzfTZMICQ40jLTMjSn4hTYcVRGEFMvnWXpEEUYYWTGoENHIDSz4RZHYFUVgEd2YEYSUEagoFLogjcyfVS34xPLYmKCwjcPkWSwXVdLICQo0DZtHTVukEaYASSWoUczX0SnQTZKYGRBgjdqcjXqASZHY2LBwzLLkGS4wTdLkGUC4zcXMjSw3RZLglKRE1amczT00TLZgCRBwDZtH0XuMVUZoVTGoENHgWS4QUZHYFUWoERUYkVsclQigCRB0TLtjFR0MyPt3hKt3hKt3hKt3hYRUUSTEETIckVwTjQisVTTgkdEYjKAQjYPQSPWgUdMcjKAQjct3hdA4hKt3hKt3hKtnTUv.UQAslXuk0UXoWUFE0YQcEV77RRC8Vav8lak4Fc9vyKVMEUy.Ea0cVZtMEcgQWY9.."
									}
,
									"fileref" : 									{
										"name" : "ValhallaRoom",
										"filename" : "ValhallaRoom.maxsnap",
										"filepath" : "~/Documents/Max 8/Snapshots",
										"filepos" : -1,
										"snapshotfileid" : "6f57031ac6a959e280e6749774a381ce"
									}

								}
 ]
						}

					}
,
					"text" : "vst~ 2 2 ValhallaRoom @prefer VST3",
					"varname" : "vst~",
					"viewvisibility" : 0
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-43", 0 ],
					"midpoints" : [ 189.5, 723.0, 960.0, 723.0, 960.0, 519.0, 984.5, 519.0 ],
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-44", 0 ],
					"midpoints" : [ 216.5, 723.0, 960.0, 723.0, 960.0, 510.0, 1029.5, 510.0 ],
					"source" : [ "obj-1", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 0 ],
					"source" : [ "obj-10", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 0 ],
					"source" : [ "obj-11", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 0 ],
					"source" : [ "obj-12", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-3", 0 ],
					"source" : [ "obj-13", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-3", 0 ],
					"source" : [ "obj-14", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-3", 0 ],
					"source" : [ "obj-15", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-3", 0 ],
					"source" : [ "obj-16", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-4", 0 ],
					"source" : [ "obj-17", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-5", 0 ],
					"source" : [ "obj-18", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-6", 0 ],
					"source" : [ "obj-19", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-7", 0 ],
					"source" : [ "obj-2", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-13", 0 ],
					"source" : [ "obj-20", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 1 ],
					"source" : [ "obj-21", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 0 ],
					"source" : [ "obj-21", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-34", 0 ],
					"midpoints" : [ 84.5, 422.0, 84.5, 422.0 ],
					"source" : [ "obj-22", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-14", 0 ],
					"source" : [ "obj-23", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-28", 0 ],
					"source" : [ "obj-24", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-29", 0 ],
					"source" : [ "obj-25", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-27", 1 ],
					"source" : [ "obj-26", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-27", 0 ],
					"source" : [ "obj-26", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-62", 0 ],
					"source" : [ "obj-27", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-15", 0 ],
					"source" : [ "obj-28", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-16", 0 ],
					"source" : [ "obj-29", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-45", 0 ],
					"midpoints" : [ 476.214285714285722, 723.0, 1005.0, 723.0, 1005.0, 567.0, 1029.5, 567.0 ],
					"source" : [ "obj-3", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-46", 0 ],
					"midpoints" : [ 444.5, 723.0, 960.0, 723.0, 960.0, 564.0, 984.5, 564.0 ],
					"source" : [ "obj-3", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-47", 0 ],
					"source" : [ "obj-30", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 1 ],
					"order" : 1,
					"source" : [ "obj-32", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 0 ],
					"order" : 1,
					"source" : [ "obj-32", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-22", 1 ],
					"order" : 2,
					"source" : [ "obj-32", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-22", 0 ],
					"order" : 2,
					"source" : [ "obj-32", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-3", 1 ],
					"order" : 0,
					"source" : [ "obj-32", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-3", 0 ],
					"order" : 0,
					"source" : [ "obj-32", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-34", 1 ],
					"source" : [ "obj-33", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-31", 0 ],
					"source" : [ "obj-34", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-36", 1 ],
					"source" : [ "obj-35", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-38", 0 ],
					"source" : [ "obj-36", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-60", 0 ],
					"source" : [ "obj-37", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-30", 0 ],
					"order" : 0,
					"source" : [ "obj-39", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-53", 0 ],
					"order" : 1,
					"source" : [ "obj-39", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-10", 0 ],
					"source" : [ "obj-4", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 0 ],
					"source" : [ "obj-42", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-26", 0 ],
					"source" : [ "obj-43", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-26", 1 ],
					"source" : [ "obj-44", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-26", 1 ],
					"source" : [ "obj-45", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-26", 0 ],
					"source" : [ "obj-46", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-43", 1 ],
					"order" : 1,
					"source" : [ "obj-47", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-44", 1 ],
					"order" : 0,
					"source" : [ "obj-47", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-42", 0 ],
					"source" : [ "obj-48", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-50", 0 ],
					"source" : [ "obj-49", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-12", 0 ],
					"source" : [ "obj-5", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 0 ],
					"source" : [ "obj-50", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-55", 0 ],
					"source" : [ "obj-52", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-54", 0 ],
					"source" : [ "obj-53", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-45", 1 ],
					"order" : 0,
					"source" : [ "obj-54", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-46", 1 ],
					"order" : 1,
					"source" : [ "obj-54", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 0 ],
					"source" : [ "obj-55", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-63", 0 ],
					"source" : [ "obj-59", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-11", 0 ],
					"source" : [ "obj-6", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-61", 0 ],
					"source" : [ "obj-60", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-62", 1 ],
					"source" : [ "obj-61", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-36", 0 ],
					"source" : [ "obj-62", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-21", 0 ],
					"source" : [ "obj-63", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-65", 0 ],
					"source" : [ "obj-64", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 0 ],
					"source" : [ "obj-65", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-67", 0 ],
					"source" : [ "obj-66", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 0 ],
					"source" : [ "obj-67", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-21", 1 ],
					"source" : [ "obj-7", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-21", 0 ],
					"source" : [ "obj-7", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-39", 0 ],
					"source" : [ "obj-8", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-17", 0 ],
					"midpoints" : [ 1209.5, 390.0, 189.5, 390.0 ],
					"order" : 7,
					"source" : [ "obj-9", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-18", 0 ],
					"midpoints" : [ 1209.5, 390.0, 195.0, 390.0, 195.0, 501.0, 189.5, 501.0 ],
					"order" : 6,
					"source" : [ "obj-9", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-19", 0 ],
					"midpoints" : [ 1209.5, 390.0, 195.0, 390.0, 195.0, 606.0, 189.5, 606.0 ],
					"order" : 5,
					"source" : [ "obj-9", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-20", 0 ],
					"midpoints" : [ 1209.5, 391.0, 444.5, 391.0 ],
					"order" : 4,
					"source" : [ "obj-9", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-23", 0 ],
					"midpoints" : [ 1209.5, 390.0, 375.0, 390.0, 375.0, 474.0, 444.5, 474.0 ],
					"order" : 3,
					"source" : [ "obj-9", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-24", 0 ],
					"midpoints" : [ 1209.5, 390.0, 375.0, 390.0, 375.0, 549.0, 444.5, 549.0 ],
					"order" : 2,
					"source" : [ "obj-9", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-25", 0 ],
					"midpoints" : [ 1209.5, 390.0, 375.0, 390.0, 375.0, 654.0, 444.5, 654.0 ],
					"order" : 1,
					"source" : [ "obj-9", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-37", 0 ],
					"order" : 0,
					"source" : [ "obj-9", 0 ]
				}

			}
 ],
		"parameters" : 		{
			"obj-1" : [ "vst~[4]", "vst~", 0 ],
			"obj-21" : [ "vst~[48]", "vst~[48]", 0 ],
			"obj-26" : [ "vst~[3]", "vst~[2]", 0 ],
			"obj-3" : [ "vst~[5]", "vst~", 0 ],
			"obj-32" : [ "vst~[34]", "vst~[34]", 0 ],
			"parameterbanks" : 			{
				"0" : 				{
					"index" : 0,
					"name" : "",
					"parameters" : [ "-", "-", "-", "-", "-", "-", "-", "-" ]
				}

			}
,
			"inherited_shortname" : 1
		}
,
		"dependency_cache" : [ 			{
				"name" : "Black Box Analog Design HG-2.maxsnap",
				"bootpath" : "~/Documents/Max 8/Snapshots",
				"patcherrelativepath" : "../../../../../../../../Documents/Max 8/Snapshots",
				"type" : "mx@s",
				"implicit" : 1
			}
, 			{
				"name" : "Pro-Q 3.maxsnap",
				"bootpath" : "~/Documents/Max 8/Snapshots",
				"patcherrelativepath" : "../../../../../../../../Documents/Max 8/Snapshots",
				"type" : "mx@s",
				"implicit" : 1
			}
, 			{
				"name" : "TEOTE.maxsnap",
				"bootpath" : "~/Documents/Max 8/Snapshots",
				"patcherrelativepath" : "../../../../../../../../Documents/Max 8/Snapshots",
				"type" : "mx@s",
				"implicit" : 1
			}
, 			{
				"name" : "ValhallaRoom.maxsnap",
				"bootpath" : "~/Documents/Max 8/Snapshots",
				"patcherrelativepath" : "../../../../../../../../Documents/Max 8/Snapshots",
				"type" : "mx@s",
				"implicit" : 1
			}
, 			{
				"name" : "ValhallaVintageVerb.maxsnap",
				"bootpath" : "~/Documents/Max 8/Snapshots",
				"patcherrelativepath" : "../../../../../../../../Documents/Max 8/Snapshots",
				"type" : "mx@s",
				"implicit" : 1
			}
 ],
		"autosave" : 0
	}

}
