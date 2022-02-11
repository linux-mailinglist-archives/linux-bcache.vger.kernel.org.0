Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114A54B20CE
	for <lists+linux-bcache@lfdr.de>; Fri, 11 Feb 2022 09:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiBKI5f (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 11 Feb 2022 03:57:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346085AbiBKI5f (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 11 Feb 2022 03:57:35 -0500
Received: from mail-m2836.qiye.163.com (mail-m2836.qiye.163.com [103.74.28.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A105C1020
        for <linux-bcache@vger.kernel.org>; Fri, 11 Feb 2022 00:57:33 -0800 (PST)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id C5121C05EF;
        Fri, 11 Feb 2022 16:57:29 +0800 (CST)
Message-ID: <214c96f8-dc8e-5511-ec85-40d945cf3a7c@easystack.cn>
Date:   Fri, 11 Feb 2022 16:57:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] bcache: fixup multiple threads crash
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     zoumingzhe@qq.com, linux-bcache@vger.kernel.org
References: <20220211063915.4101-1-mingzhe.zou@easystack.cn>
 <8c7314c0-4df3-5bda-f17c-7ddc15de7ffc@suse.de>
From:   Zou Mingzhe <mingzhe.zou@easystack.cn>
In-Reply-To: <8c7314c0-4df3-5bda-f17c-7ddc15de7ffc@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWUJNTkxWT0oZSE1CSUJIHU
        JDVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Njo6PBw*PzI9ERQWMDceKxEf
        DhhPCg9VSlVKTU9PTk1CQ05LSkxJVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSk5KSEs3Bg++
X-HM-Tid: 0a7ee8007042841ekuqwc5121c05ef
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


在 2022/2/11 16:39, Coly Li 写道:
> On 2/11/22 2:39 PM, mingzhe.zou@easystack.cn wrote:
>> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>
>> When multiple threads to check btree nodes in parallel, the main
>> thread wait for all threads to stop or CACHE_SET_IO_DISABLE flag:
>>
>> wait_event_interruptible(check_state->wait,
>> atomic_read(&check_state->started) == 0 ||
>>                           test_bit(CACHE_SET_IO_DISABLE, &c->flags));
>>
>> However, the bch_btree_node_read and bch_btree_node_read_done
>> maybe call bch_cache_set_error, then the CACHE_SET_IO_DISABLE
>> will be set. If the flag already set, the main thread return
>> error. At the same time, maybe some threads still running and
>> read NULL pointer, the kernel will crash.
>
> Hi Mingzhe,
>
> Could you please explain a bit more about "read NULL pointer"? Which 
> NULL pointer might be read in the above condition?
>
> Thanks.
>
> Coly Li

Hi ColyLi:


This is dmesg output information:

[956549.478889] bcache: bch_cache_set_error() bcache: error on 
c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8:
[956549.492265] unsupported bset version at bucket 78226, block 0, 
282468165 keys
[956549.492266] bcache: bch_cache_set_error() , disabling caching

[956549.531298] bcache: conditional_stop_bcache_device() 
stop_when_cache_set_failed of escache2 is "auto" and cache is dirty, 
stop it to avoid potential data corruption.
[956549.557162] bcache: cached_dev_detach_finish() Caching disabled for sdc1
[956549.570292] bcache: bcache_device_free() escache2 stopped
[956549.603434] bcache: cache_set_free() Cache set 
c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8 unregistered
[956583.000094] bcache: bch_cache_set_error() bcache: error on 
4f45b0b1-32ea-4d83-a2b1-caa169a95b35:
[956583.013567] unsupported bset version at bucket 25452, block 0, 
208758840 keys
[956583.013569] bcache: bch_cache_set_error() , disabling caching

[956583.053296] bcache: conditional_stop_bcache_device() 
stop_when_cache_set_failed of escache1 is "auto" and cache is dirty, 
stop it to avoid potential data corruption.
[956583.079968] bcache: cached_dev_detach_finish() Caching disabled for sdd1
[956583.093539] bcache: bcache_device_free() escache1 stopped
[956583.126677] bcache: cache_set_free() Cache set 
4f45b0b1-32ea-4d83-a2b1-caa169a95b35 unregistered
[956589.522067]  sdc: sdc1
[956590.291748] bcache: register_bdev() registered backing device sdc1
[956590.307925] bcache: cache_alloc() set 
c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8 with btree_buckets: 256, free: 128, 
free_inc: 11264, heap: 22528

[956590.406700] bcache: bch_cache_set_error() bcache: error on 
c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8:
[956590.411369] bcache: bch_cache_set_error() CACHE_SET_IO_DISABLE 
already set
[956590.412453] bcache: bch_cache_set_error() CACHE_SET_IO_DISABLE 
already set
[956590.412455] bcache: bch_cache_set_error() bcache: error on 
c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8:
[956590.412456] io error reading bucket 81152
[956590.412456] bcache: bch_cache_set_error() , disabling caching

[956590.412578] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000010
[956590.412594] PGD 0 P4D 0
[956590.412624] Oops: 0000 [#1] SMP PTI
[956590.412645] CPU: 12 PID: 55477 Comm: bch_btrchk[9] Kdump: loaded 
Tainted: G           OE    --------- -  - 
4.18.0-147.5.1.el8_1.5es.16.x86_64 #1
[956590.412646] Hardware name: Tsinghua Tongfang THTF Chaoqiang 
Server/072T6D, BIOS 2.4.3 01/17/2017
[956590.412859] RIP: 0010:bch_btree_node_read_done+0x1e9/0x400 [escache]
[956590.412868] Code: 11 00 00 45 89 d3 0f b7 c0 41 c1 e3 09 49 89 c6 41 
0f af d3 49 d3 ee 4c 89 f1 48 63 d2 49 8d 1c 10 45 39 f1 0f 83 da 00 00 
00 <4d> 8b 78 10 4c 39 7b 10 0f 85 d4 01 00 00 44 8b 43 18 41 83 f8 01
[956590.412870] RSP: 0018:ffffac308ec4fd58 EFLAGS: 00010283
[956590.412882] RAX: 0000000000000200 RBX: 0000000000035600 RCX: 
0000000000000200
[956590.412883] RDX: 0000000000035600 RSI: 00000000000001ab RDI: 
ffff911fcac20000
[956590.412889] RBP: ffff911f090f7000 R08: 0000000000000000 R09: 
00000000000001ab
[956590.412890] R10: 0000000000000001 R11: 0000000000000200 R12: 
ffff910fb3238000
[956590.412891] R13: 90135c78b99e07f5 R14: 0000000000000200 R15: 
ffff9119994b4620
[956590.412896] FS:  0000000000000000(0000) GS:ffff91107f980000(0000) 
knlGS:0000000000000000
[956590.412898] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[956590.412902] bcache: cache_set_free() Cache set 
c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8 unregistered
[956590.412911] CR2: 0000000000000010 CR3: 0000001534e0a002 CR4: 
00000000003626e0
[956590.412925] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[956590.412926] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[956590.412928] Call Trace:
[956590.412941]  bch_btree_node_read+0xe7/0x1a0 [escache]
[956590.412953]  ? bch_keybuf_init+0x60/0x60 [escache]
[956590.412976]  ? bch_ptr_invalid+0x10/0x10 [escache]
[956590.413002]  btree_node_prefetch+0x6e/0x90 [escache]
[956590.413025]  bch_btree_check_thread+0x15c/0x270 [escache]
[956590.413089]  ? finish_task_switch+0xd7/0x2b0
[956590.413099]  ? bch_btree_check_recurse+0x1b0/0x1b0 [escache]
[956590.413131]  kthread+0x112/0x130
[956590.413139]  ? kthread_flush_work_fn+0x10/0x10
[956590.413164]  ret_from_fork+0x35/0x40
[956590.413191] Modules linked in: iscsi_target_mod target_core_mod 
vhost_net vhost tap tun tcp_diag udp_diag inet_diag unix_diag ext4 
mbcache jbd2 nbd sch_htb act_police cls_u32 sch_ingress xt_connmark 
xt_CHECKSUM ip_set ip_gre ip_tunnel gre ebtable_filter ebtables 
ip6table_filter nf_nat_pptp nf_nat_proto_gre nf_conntrack_pptp 
nf_conntrack_proto_gre veth nf_conntrack_netlink nfnetlink ip6table_nat 
ip6_tables overlay iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi 
vxlan ip6_udp_tunnel udp_tunnel openvswitch nf_nat_ipv6 nf_conncount 
ipt_REJECT nf_reject_ipv4 iptable_filter xt_conntrack iptable_mangle 
xt_statistic xt_nat ipt_MASQUERADE xt_comment xt_addrtype xt_recent 
xt_mark iptable_nat nf_nat_ipv4 nf_nat iptable_raw vfat fat intel_rapl 
sb_edac x86_pkg_temp_thermal mxm_wmi intel_powerclamp coretemp
[956590.413654]  kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel intel_cstate intel_uncore intel_rapl_perf pcspkr 
mei_me mei joydev lpc_ich sg ipmi_si acpi_power_meter wmi escache nfsd 
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 
auth_rpcgss br_netfilter bridge nfs_acl lockd grace stp llc sunrpc 
nf_conntrack ip_tables xfs sd_mod drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops ttm ixgbe nvme drm ahci libahci libata nvme_core 
igb mdio dca i2c_algo_bit megaraid_sas(OE) dm_mirror dm_region_hash 
dm_log dm_mod rbd libceph dns_resolver ipmi_watchdog ipmi_devintf 
ipmi_msghandler drbd_transport_tcp(OE) drbd(OE) libcrc32c crc32c_intel
[956590.413942] CR2: 0000000000000010

I see some print "bcache: bch_cache_set_error() bcache: error on", but I 
don't have any more information on how to go wrong.

Then the 'bcache: bch_cache_set_error() CACHE_SET_IO_DISABLE already 
set' mean the CACHE_SET_IO_DISABLE flag has been set and the main thread 
will return error.

At the same time, some threads is running bch_btree_check and read NULL 
pointer.


After hitting this patch:

[ 5963.884744] bcache: register_bdev() registered backing device sdb1
[ 5963.893115] bcache: cache_alloc() set 
63c108be-681f-4631-bee3-9746e6a86c3d with btree_buckets: 8, free: 128, 
free_inc: 11264, heap: 22528
[ 5963.906020] bcache: run_cache_set() invalidating existing data
[ 5963.910478] bcache: bch_btree_gc_finish() finish gc: on set 
63c108be-681f-4631-bee3-9746e6a86c3d, avail_nbuckets is 102143
[ 5963.945916] bcache: bch_cached_dev_run() cached dev sdb1 is running 
already
[ 5963.950523] bcache: bch_cached_dev_attach() Caching sdb1 as escache0 
on set 63c108be-681f-4631-bee3-9746e6a86c3d
[ 5963.955353] bcache: register_cache() registered cache device sdn4
[ 5988.451111] bcache: register_bdev() registered backing device sdc1
[ 5988.462182] bcache: cache_alloc() set 
1be49234-3e51-4c92-9d67-e734b4399c37 with btree_buckets: 8, free: 128, 
free_inc: 11264, heap: 22528
[ 5988.481939] bcache: run_cache_set() invalidating existing data
[ 5988.488553] bcache: bch_btree_gc_finish() finish gc: on set 
1be49234-3e51-4c92-9d67-e734b4399c37, avail_nbuckets is 102143
[ 5988.529246] bcache: bch_cached_dev_run() cached dev sdc1 is running 
already
[ 5988.536157] bcache: bch_cached_dev_attach() Caching sdc1 as escache1 
on set 1be49234-3e51-4c92-9d67-e734b4399c37
[ 5988.543267] bcache: register_cache() registered cache device sdn8
[ 6006.682360] bcache: btree_gc_start() start gc: on set 
63c108be-681f-4631-bee3-9746e6a86c3d
[ 6006.910827] bcache: bch_btree_gc_finish() finish gc: on set 
63c108be-681f-4631-bee3-9746e6a86c3d, avail_nbuckets is 85876
[ 6033.096685] bcache: btree_gc_start() start gc: on set 
63c108be-681f-4631-bee3-9746e6a86c3d
[ 6033.333707] bcache: bch_btree_gc_finish() finish gc: on set 
63c108be-681f-4631-bee3-9746e6a86c3d, avail_nbuckets is 86050
[ 6050.566047] bcache: btree_gc_start() start gc: on set 
1be49234-3e51-4c92-9d67-e734b4399c37
[ 6050.805677] bcache: bch_btree_gc_finish() finish gc: on set 
1be49234-3e51-4c92-9d67-e734b4399c37, avail_nbuckets is 85887
[ 6062.906385] bcache: btree_gc_start() start gc: on set 
63c108be-681f-4631-bee3-9746e6a86c3d
[ 6063.213631] bcache: bch_btree_gc_finish() finish gc: on set 
63c108be-681f-4631-bee3-9746e6a86c3d, avail_nbuckets is 72381
[ 6088.694073] bcache: btree_gc_start() start gc: on set 
1be49234-3e51-4c92-9d67-e734b4399c37
[ 6088.909585] bcache: bch_btree_gc_finish() finish gc: on set 
1be49234-3e51-4c92-9d67-e734b4399c37, avail_nbuckets is 86096
[ 6091.919511] bcache: btree_gc_start() start gc: on set 
63c108be-681f-4631-bee3-9746e6a86c3d
[ 6092.301603] bcache: bch_btree_gc_finish() finish gc: on set 
63c108be-681f-4631-bee3-9746e6a86c3d, avail_nbuckets is 76844
[ 6097.862532] bcache: register_bdev() registered backing device sdd1
[ 6097.875814] bcache: cache_alloc() set 
afca5e79-a369-48ce-94cf-671b963294f6 with btree_buckets: 8, free: 128, 
free_inc: 11264, heap: 22528
[ 6097.902563] bcache: run_cache_set() invalidating existing data
[ 6097.911899] bcache: bch_btree_gc_finish() finish gc: on set 
afca5e79-a369-48ce-94cf-671b963294f6, avail_nbuckets is 102143
[ 6098.006412] bcache: bch_cached_dev_run() cached dev sdd1 is running 
already
[ 6098.015707] bcache: bch_cached_dev_attach() Caching sdd1 as escache2 
on set afca5e79-a369-48ce-94cf-671b963294f6
[ 6098.025091] bcache: register_cache() registered cache device sdn12
[ 6127.728289] bcache: btree_gc_start() start gc: on set 
1be49234-3e51-4c92-9d67-e734b4399c37
[ 6128.005631] bcache: bch_btree_gc_finish() finish gc: on set 
1be49234-3e51-4c92-9d67-e734b4399c37, avail_nbuckets is 73082
[ 6135.932387] bcache: btree_gc_start() start gc: on set 
63c108be-681f-4631-bee3-9746e6a86c3d
[ 6136.301490] bcache: bch_btree_gc_finish() finish gc: on set 
63c108be-681f-4631-bee3-9746e6a86c3d, avail_nbuckets is 83915
[ 6169.055871] bcache: register_bdev() registered backing device sde1
[ 6169.073666] bcache: cache_alloc() set 
bccbd1d0-95f5-4cd1-93b0-5869db4b2bd3 with btree_buckets: 8, free: 128, 
free_inc: 11264, heap: 22528
[ 6169.098886] bcache: run_cache_set() invalidating existing data
[ 6169.106788] bcache: bch_btree_gc_finish() finish gc: on set 
bccbd1d0-95f5-4cd1-93b0-5869db4b2bd3, avail_nbuckets is 102143
[ 6169.150450] bcache: bch_cached_dev_run() cached dev sde1 is running 
already
[ 6169.158346] bcache: bch_cached_dev_attach() Caching sde1 as escache3 
on set bccbd1d0-95f5-4cd1-93b0-5869db4b2bd3
[ 6169.166344] bcache: register_cache() registered cache device sdn16


I see some print "bcache: run_cache_set() invalidating existing data".


Mingzhe

>
>> This patch change the event wait condition, the main thread must
>> wait for all threads to stop.
>>
>> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
>> ---
>>   drivers/md/bcache/btree.c     | 6 ++++--
>>   drivers/md/bcache/writeback.c | 6 ++++--
>>   2 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> index 88c573eeb598..ad9f16689419 100644
>> --- a/drivers/md/bcache/btree.c
>> +++ b/drivers/md/bcache/btree.c
>> @@ -2060,9 +2060,11 @@ int bch_btree_check(struct cache_set *c)
>>           }
>>       }
>>   +    /*
>> +     * Must wait for all threads to stop.
>> +     */
>>       wait_event_interruptible(check_state->wait,
>> -                 atomic_read(&check_state->started) == 0 ||
>> -                  test_bit(CACHE_SET_IO_DISABLE, &c->flags));
>> +                 atomic_read(&check_state->started) == 0);
>>         for (i = 0; i < check_state->total_threads; i++) {
>>           if (check_state->infos[i].result) {
>> diff --git a/drivers/md/bcache/writeback.c 
>> b/drivers/md/bcache/writeback.c
>> index c7560f66dca8..68d3dd6b4f11 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -998,9 +998,11 @@ void bch_sectors_dirty_init(struct bcache_device 
>> *d)
>>           }
>>       }
>>   +    /*
>> +     * Must wait for all threads to stop.
>> +     */
>>       wait_event_interruptible(state->wait,
>> -         atomic_read(&state->started) == 0 ||
>> -         test_bit(CACHE_SET_IO_DISABLE, &c->flags));
>> +         atomic_read(&state->started) == 0);
>>     out:
>>       kfree(state);
>
>
