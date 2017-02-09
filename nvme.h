/*
 * Definitions for the NVM Express interface
 * Copyright (c) 2011-2014, Intel Corporation.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 */

#ifndef _NVME_H
#define _NVME_H

#include <stdbool.h>
#include "plugin.h"

#define unlikely(x) x
#include "linux/nvme.h"

struct nvme_error_log_page {
	__u64	error_count;
	__u16	sqid;
	__u16	cmdid;
	__u16	status_field;
	__u16	parm_error_location;
	__u64	lba;
	__u32	nsid;
	__u8	vs;
	__u8	resv[35];
};

struct nvme_firmware_log_page {
	__u8	afi;
	__u8	resv[7];
	__u64	frs[7];
	__u8	resv2[448];
};

/* idle and active power scales occupy the last 2 bits of the field */
#define POWER_SCALE(s) ((s) >> 6)

enum {
	NVME_ID_CNS_NS			= 0x00,
	NVME_ID_CNS_CTRL		= 0x01,
	NVME_ID_CNS_NS_ACTIVE_LIST	= 0x02,
	NVME_ID_CNS_NS_PRESENT_LIST	= 0x10,
	NVME_ID_CNS_NS_PRESENT		= 0x11,
	NVME_ID_CNS_CTRL_NS_LIST	= 0x12,
	NVME_ID_CNS_CTRL_LIST		= 0x13,
};

#pragma pack(push,1)
struct nvme_additional_smart_log_item {
	__u8			key;
	__u8			_kp[2];
	__u8			norm;
	__u8			_np;
	union {
		__u8		raw[6];
		struct wear_level {
			__le16	min;
			__le16	max;
			__le16	avg;
		} wear_level ;
		struct thermal_throttle {
			__u8	pct;
			__u32	count;
		} thermal_throttle;
	};
	__u8			_rp;
};
#pragma pack(pop)

#pragma pack(push,1)
struct nvme_additional_smart_log {
	struct nvme_additional_smart_log_item	program_fail_cnt;
	struct nvme_additional_smart_log_item	erase_fail_cnt;
	struct nvme_additional_smart_log_item	wear_leveling_cnt;
	struct nvme_additional_smart_log_item	e2e_err_cnt;
	struct nvme_additional_smart_log_item	crc_err_cnt;
	struct nvme_additional_smart_log_item	timed_workload_media_wear;
	struct nvme_additional_smart_log_item	timed_workload_host_reads;
	struct nvme_additional_smart_log_item	timed_workload_timer;
	struct nvme_additional_smart_log_item	thermal_throttle_status;
	struct nvme_additional_smart_log_item	retry_buffer_overflow_cnt;
	struct nvme_additional_smart_log_item	pll_lock_loss_cnt;
	struct nvme_additional_smart_log_item	nand_bytes_written;
	struct nvme_additional_smart_log_item	host_bytes_written;
	__u8			rsvd100[100];
	__u32			lifetime_waf;
	__u32			trailing_hour_waf;
	__u8			lifetime_user_writes[16];
	__u8			lifetime_nand_writes[16];
	__u8			lifetime_user_reads[16];
	__u32			lifetime_retired_block_count;
	__u16			current_temperature;
	__u16			capacitor_health;
	__u32			lifetime_unused_reserved_blocks;
	__u64			read_reclaim_count;
	__u64			lifetime_uecc_count;
	__u32			lifetime_used_reserved_blocks;
	__u8			power_on_hours[16];
	__u8			lifetime_clean_shutdown[16];
	__u8			lifetime_unclean_shutdown[16];
	__u32			perf_indicator;
	__u32			wear_level_count;
	__u8			rsvd112[112];
};
#pragma pack(pop)

#pragma pack(push,1)
struct nvme_ms_ext_smart_log_c0 {
	__u8			media_units_written[16];
	__u8			capacitor_health;
	__u8			ecc_iterations[16];
	__u8			supercapacitor_support;
	__u8			temperature_throttling[7];
	__u8			power_consumption;
	__u8			wear_range_delta;
	__u8			unaligned_io[6];
	__u32			mapped_lbas;
	__u8			program_fail_count;
	__u8			erase_fail_count;
	__u32			max_controller_temp;
	__u32			max_name_temp;
	__u32			controller_meltdown_count;
	__u32			nand_meltdown_count;
	__u32			controller_dtt_count;
	__u32			nand_dtt_count;
	__u8			rsvd117[117];
};
#pragma pack(pop)

#pragma pack(push,1)
struct nvme_ms_ext_smart_log_c1 {
	__u8			log_page_id;
	__u8			rsvd1;
	__u16			flags;
	__u32			log_page_size;
	__u64			data_change_internal;
	__u8			rsvd16[16];
	__u32			lifetime_waf;
	__u32			trailing_hour_waf;
	__u32			percentage_pe_cycle_remaining;
	__u8			lifetime_user_writes[16];
	__u8			lifetime_nand_writes[16];
	__u8			lifetime_user_reads[16];
	__u32			lifetime_retired_block_count;
	__u16			current_temperature;
	__u16			capacitor_health;
	__u32			reserve_block_count;
	__u64			lifetime_read_reclaim_count;
	__u64			lifetime_uecc_reclaim_count;
	__u32			lifetime_reallocated_sector_count;
	__u8			power_on_hours[16];
	__u8			lifetime_clean_shutdown_count[16];
	__u8			lifetime_unclean_shutdown_count[16];
	__u32			perf_indicator;
	__u32			wear_level_count;
	__u32			bad_tlp_count;
	__u32			bad_dllp_count;
	__u32			phy_error_count;
};
#pragma pack(pop)

struct nvme_host_mem_buffer {
	__u32			hsize;
	__u32			hmdlal;
	__u32			hmdlau;
	__u32			hmdlec;
	__u8			rsvd16[4080];
};

struct nvme_auto_pst {
	__u32	data;
	__u32	rsvd32;
};

struct nvme_controller_list {
	__le16 num;
	__le16 identifier[];
};

struct nvme_bar_cap {
	__u16	mqes;
	__u8	ams_cqr;
	__u8	to;
	__u16	css_nssrs_dstrd;
	__u8	mpsmax_mpsmin;
	__u8	reserved;
};

#ifdef __CHECKER__
#define __force       __attribute__((force))
#else
#define __force
#endif

#define cpu_to_le16(x) \
	((__force __le16)htole16(x))
#define cpu_to_le32(x) \
	((__force __le32)htole32(x))
#define cpu_to_le64(x) \
	((__force __le64)htole64(x))

#define le16_to_cpu(x) \
	le16toh((__force __u16)(x))
#define le32_to_cpu(x) \
	le32toh((__force __u32)(x))
#define le64_to_cpu(x) \
	le64toh((__force __u64)(x))

#define MAX_LIST_ITEMS 256
struct list_item {
	char                node[1024];
	struct nvme_id_ctrl ctrl;
	int                 nsid;
	struct nvme_id_ns   ns;
	unsigned            block;
};

void register_extension(struct plugin *plugin);

#include "argconfig.h"
int parse_and_open(int argc, char **argv, const char *desc,
	const struct argconfig_commandline_options *clo, void *cfg, size_t size);

extern const char *devicename;

int __id_ctrl(int argc, char **argv, struct command *cmd, struct plugin *plugin, void (*vs)(__u8 *vs));

#endif /* _NVME_H */
