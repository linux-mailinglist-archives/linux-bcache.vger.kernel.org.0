Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85444C0EE0
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Feb 2022 10:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbiBWJKj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Feb 2022 04:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbiBWJKj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Feb 2022 04:10:39 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4C48021F
        for <linux-bcache@vger.kernel.org>; Wed, 23 Feb 2022 01:10:11 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D113221129;
        Wed, 23 Feb 2022 09:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645607409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u9WHEKyZg/0RxtXmQnM62q9ajplPa6mGYUsqVHgntbM=;
        b=K+8IYDT5pl15C7JaaGkcA+BACHxcmpcVvN0jjgc+CvqI+sPin9NCsCupaXzBxU4+FX9Xsh
        HCTVURDUg6W2wOibvCoRqTVpS4H04VAqjzkth7nqbN52yRdcVUkAKYSKVZwGpOBw1kvybl
        7epO/R+/AbOLW+1L0X5nyVAZtLTcGds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645607409;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u9WHEKyZg/0RxtXmQnM62q9ajplPa6mGYUsqVHgntbM=;
        b=xin7T8nlTjpiQlBkNGsWPFXyoKcyV3U1WIqEOyx5yMb0rwH9umFMs4zY5Hyjdj1G3NhRJZ
        cn3fTD2ccM07y2Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8174113C51;
        Wed, 23 Feb 2022 09:10:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ppRjC/D5FWLXIgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 23 Feb 2022 09:10:08 +0000
Message-ID: <fbc725bf-0786-87a1-cb2c-7f1b6b63e47e@suse.de>
Date:   Wed, 23 Feb 2022 17:10:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] bcache: fixup multiple threads crash
Content-Language: en-US
To:     Zou Mingzhe <mingzhe.zou@easystack.cn>
Cc:     zoumingzhe@qq.com, linux-bcache@vger.kernel.org
References: <20220211063915.4101-1-mingzhe.zou@easystack.cn>
 <8c7314c0-4df3-5bda-f17c-7ddc15de7ffc@suse.de>
 <214c96f8-dc8e-5511-ec85-40d945cf3a7c@easystack.cn>
 <551d44a7-8e87-2100-e395-04de8e1e45c3@suse.de>
 <5b4ae28e-8b0c-20b4-00eb-53e2076b47ba@easystack.cn>
 <6e10e77c-e20c-4686-8b4e-1a2e177ed3aa@easystack.cn>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <6e10e77c-e20c-4686-8b4e-1a2e177ed3aa@easystack.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/14/22 3:46 PM, Zou Mingzhe wrote:
> 在 2022/2/12 20:25, Zou Mingzhe 写道:
>>
>> 在 2022/2/11 19:38, Coly Li 写道:
>>> On 2/11/22 4:57 PM, Zou Mingzhe wrote:
>>>>
>>>> 在 2022/2/11 16:39, Coly Li 写道:
>>>>> On 2/11/22 2:39 PM, mingzhe.zou@easystack.cn wrote:
>>>>>> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>>>>>
>>>>>> When multiple threads to check btree nodes in parallel, the main
>>>>>> thread wait for all threads to stop or CACHE_SET_IO_DISABLE flag:
>>>>>>
>>>>>> wait_event_interruptible(check_state->wait,
>>>>>> atomic_read(&check_state->started) == 0 ||
>>>>>>                           test_bit(CACHE_SET_IO_DISABLE, 
>>>>>> &c->flags));
>>>>>>
>>>>>> However, the bch_btree_node_read and bch_btree_node_read_done
>>>>>> maybe call bch_cache_set_error, then the CACHE_SET_IO_DISABLE
>>>>>> will be set. If the flag already set, the main thread return
>>>>>> error. At the same time, maybe some threads still running and
>>>>>> read NULL pointer, the kernel will crash.
>>>>>
>>>>> Hi Mingzhe,
>>>>>
>>>>> Could you please explain a bit more about "read NULL pointer"? 
>>>>> Which NULL pointer might be read in the above condition?
>>>>>
>>>>> Thanks.
>>>>>
>>>>> Coly Li
>>>>
>>>> Hi ColyLi:
>>>>
>>>>
>>>> This is dmesg output information:
>>>>
>>>> [956549.478889] bcache: bch_cache_set_error() bcache: error on 
>>>> c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8:
>>>> [956549.492265] unsupported bset version at bucket 78226, block 0, 
>>>> 282468165 keys
>>>> [956549.492266] bcache: bch_cache_set_error() , disabling caching
>>>
>>> What happens here? It seems the btree node is corrupted with 
>>> unexpected bset version.
>>>
>>>
>>>>
>>>> [956549.531298] bcache: conditional_stop_bcache_device() 
>>>> stop_when_cache_set_failed of escache2 is "auto" and cache is 
>>>> dirty, stop it to avoid potential data corruption.
>>>> [956549.557162] bcache: cached_dev_detach_finish() Caching disabled 
>>>> for sdc1
>>>> [956549.570292] bcache: bcache_device_free() escache2 stopped
>>>> [956549.603434] bcache: cache_set_free() Cache set 
>>>> c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8 unregistered[956583.000094] 
>>>> bcache: bch_cache_set_error() bcache: error on 
>>>> 4f45b0b1-32ea-4d83-a2b1-caa169a95b35:
>>>> [956583.013567] unsupported bset version at bucket 25452, block 0, 
>>>> 208758840 keys
>>>> [956583.013569] bcache: bch_cache_set_error() , disabling caching
>>>
>>> Similar corrupted btree node here.
>>>
>>> The corrupted btree node should be the first thing to look into.
>>>
>>>
>>>>
>>>> [956583.053296] bcache: conditional_stop_bcache_device() 
>>>> stop_when_cache_set_failed of escache1 is "auto" and cache is 
>>>> dirty, stop it to avoid potential data corruption.
>>>> [956583.079968] bcache: cached_dev_detach_finish() Caching disabled 
>>>> for sdd1
>>>> [956583.093539] bcache: bcache_device_free() escache1 stopped
>>>> [956583.126677] bcache: cache_set_free() Cache set 
>>>> 4f45b0b1-32ea-4d83-a2b1-caa169a95b35 unregistered
>>>> [956589.522067]  sdc: sdc1
>>>> [956590.291748] bcache: register_bdev() registered backing device sdc1
>>>> [956590.307925] bcache: cache_alloc() set 
>>>> c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8 with btree_buckets: 256, free: 
>>>> 128, free_inc: 11264, heap: 22528
>>>>
>>>> [956590.406700] bcache: bch_cache_set_error() bcache: error on 
>>>> c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8:
>>>> [956590.411369] bcache: bch_cache_set_error() CACHE_SET_IO_DISABLE 
>>>> already set
>>>> [956590.412453] bcache: bch_cache_set_error() CACHE_SET_IO_DISABLE 
>>>> already set
>>>> [956590.412455] bcache: bch_cache_set_error() bcache: error on 
>>>> c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8:
>>>> [956590.412456] io error reading bucket 81152
>>>> [956590.412456] bcache: bch_cache_set_error() , disabling caching
>>>>
>>>> [956590.412578] BUG: unable to handle kernel NULL pointer 
>>>> dereference at 0000000000000010
>>>> [956590.412594] PGD 0 P4D 0
>>>> [956590.412624] Oops: 0000 [#1] SMP PTI
>>>> [956590.412645] CPU: 12 PID: 55477 Comm: bch_btrchk[9] Kdump: 
>>>> loaded Tainted: G           OE    --------- -  - 
>>>> 4.18.0-147.5.1.el8_1.5es.16.x86_64 #1
>>>> [956590.412646] Hardware name: Tsinghua Tongfang THTF Chaoqiang 
>>>> Server/072T6D, BIOS 2.4.3 01/17/2017
>>>> [956590.412859] RIP: 0010:bch_btree_node_read_done+0x1e9/0x400 
>>>> [escache]
>>>> [956590.412868] Code: 11 00 00 45 89 d3 0f b7 c0 41 c1 e3 09 49 89 
>>>> c6 41 0f af d3 49 d3 ee 4c 89 f1 48 63 d2 49 8d 1c 10 45 39 f1 0f 
>>>> 83 da 00 00 00 <4d> 8b 78 10 4c 39 7b 10 0f 85 d4 01 00 00 44 8b 43 
>>>> 18 41 83 f8 01
>>>> [956590.412870] RSP: 0018:ffffac308ec4fd58 EFLAGS: 00010283
>>>> [956590.412882] RAX: 0000000000000200 RBX: 0000000000035600 RCX: 
>>>> 0000000000000200
>>>> [956590.412883] RDX: 0000000000035600 RSI: 00000000000001ab RDI: 
>>>> ffff911fcac20000
>>>> [956590.412889] RBP: ffff911f090f7000 R08: 0000000000000000 R09: 
>>>> 00000000000001ab
>>>> [956590.412890] R10: 0000000000000001 R11: 0000000000000200 R12: 
>>>> ffff910fb3238000
>>>> [956590.412891] R13: 90135c78b99e07f5 R14: 0000000000000200 R15: 
>>>> ffff9119994b4620
>>>> [956590.412896] FS:  0000000000000000(0000) 
>>>> GS:ffff91107f980000(0000) knlGS:0000000000000000
>>>> [956590.412898] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [956590.412902] bcache: cache_set_free() Cache set 
>>>> c5f7cdbf-fe07-4bc3-99f5-47119a3d2af8 unregistered
>>
>>
>> It seems that cache_set_free is called in run_cache_set's err.
>>
>>
>>>> [956590.412911] CR2: 0000000000000010 CR3: 0000001534e0a002 CR4: 
>>>> 00000000003626e0
>>>> [956590.412925] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
>>>> 0000000000000000
>>>> [956590.412926] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
>>>> 0000000000000400
>>>> [956590.412928] Call Trace:
>>>> [956590.412941]  bch_btree_node_read+0xe7/0x1a0 [escache]
>>>> [956590.412953]  ? bch_keybuf_init+0x60/0x60 [escache]
>>>> [956590.412976]  ? bch_ptr_invalid+0x10/0x10 [escache]
>>>> [956590.413002]  btree_node_prefetch+0x6e/0x90 [escache]
>>>> [956590.413025]  bch_btree_check_thread+0x15c/0x270 [escache]
>>>> [956590.413089]  ? finish_task_switch+0xd7/0x2b0
>>>> [956590.413099]  ? bch_btree_check_recurse+0x1b0/0x1b0 [escache]
>>>> [956590.413131]  kthread+0x112/0x130
>>>> [956590.413139]  ? kthread_flush_work_fn+0x10/0x10
>>>> [956590.413164]  ret_from_fork+0x35/0x40
>>>> [956590.413191] Modules linked in: iscsi_target_mod target_core_mod 
>>>> vhost_net vhost tap tun tcp_diag udp_diag inet_diag unix_diag ext4 
>>>> mbcache jbd2 nbd sch_htb act_police cls_u32 sch_ingress xt_connmark 
>>>> xt_CHECKSUM ip_set ip_gre ip_tunnel gre ebtable_filter ebtables 
>>>> ip6table_filter nf_nat_pptp nf_nat_proto_gre nf_conntrack_pptp 
>>>> nf_conntrack_proto_gre veth nf_conntrack_netlink nfnetlink 
>>>> ip6table_nat ip6_tables overlay iscsi_tcp libiscsi_tcp libiscsi 
>>>> scsi_transport_iscsi vxlan ip6_udp_tunnel udp_tunnel openvswitch 
>>>> nf_nat_ipv6 nf_conncount ipt_REJECT nf_reject_ipv4 iptable_filter 
>>>> xt_conntrack iptable_mangle xt_statistic xt_nat ipt_MASQUERADE 
>>>> xt_comment xt_addrtype xt_recent xt_mark iptable_nat nf_nat_ipv4 
>>>> nf_nat iptable_raw vfat fat intel_rapl sb_edac x86_pkg_temp_thermal 
>>>> mxm_wmi intel_powerclamp coretemp
>>>> [956590.413654]  kvm_intel kvm irqbypass crct10dif_pclmul 
>>>> crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore 
>>>> intel_rapl_perf pcspkr mei_me mei joydev lpc_ich sg ipmi_si 
>>>> acpi_power_meter wmi escache nfsd nf_conntrack_ipv6 nf_defrag_ipv6 
>>>> nf_conntrack_ipv4 nf_defrag_ipv4 auth_rpcgss br_netfilter bridge 
>>>> nfs_acl lockd grace stp llc sunrpc nf_conntrack ip_tables xfs 
>>>> sd_mod drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops 
>>>> ttm ixgbe nvme drm ahci libahci libata nvme_core igb mdio dca 
>>>> i2c_algo_bit megaraid_sas(OE) dm_mirror dm_region_hash dm_log 
>>>> dm_mod rbd libceph dns_resolver ipmi_watchdog ipmi_devintf 
>>>> ipmi_msghandler drbd_transport_tcp(OE) drbd(OE) libcrc32c crc32c_intel
>>>> [956590.413942] CR2: 0000000000000010
>>>>
>>>> I see some print "bcache: bch_cache_set_error() bcache: error on", 
>>>> but I don't have any more information on how to go wrong.
>>>>
>>>> Then the 'bcache: bch_cache_set_error() CACHE_SET_IO_DISABLE 
>>>> already set' mean the CACHE_SET_IO_DISABLE flag has been set and 
>>>> the main thread will return error.
>>>>
>>>> At the same time, some threads is running bch_btree_check and read 
>>>> NULL pointer.
>>>>
>>>
>>> As I asked before, can you tell which NULL pointer was read to 
>>> trigger the NULL pointer deference ? Then I can evaluate whether the 
>>> fix is efficient.
>>>
>>> [snipped]
>>
>>
>> crash> bt
>> PID: 55477  TASK: ffff9110027b5f00  CPU: 12  COMMAND: "bch_btrchk[9]"
>>  #0 [ffffac308ec4fac0] machine_kexec at ffffffffb8c5879e
>>  #1 [ffffac308ec4fb18] __crash_kexec at ffffffffb8d55e1d
>>  #2 [ffffac308ec4fbe0] crash_kexec at ffffffffb8d56d1d
>>  #3 [ffffac308ec4fbf8] oops_end at ffffffffb8c20e8d
>>  #4 [ffffac308ec4fc18] no_context at ffffffffb8c6780e
>>  #5 [ffffac308ec4fc70] do_page_fault at ffffffffb8c68342
>>  #6 [ffffac308ec4fca0] page_fault at ffffffffb960114e
>>     [exception RIP: bch_btree_node_read_done+489]
>>     RIP: ffffffffc06c6569  RSP: ffffac308ec4fd58  RFLAGS: 00010283
>>     RAX: 0000000000000200  RBX: 0000000000035600  RCX: 0000000000000200
>>     RDX: 0000000000035600  RSI: 00000000000001ab  RDI: ffff911fcac20000
>>     RBP: ffff911f090f7000   R8: 0000000000000000   R9: 00000000000001ab
>>     R10: 0000000000000001  R11: 0000000000000200  R12: ffff910fb3238000
>>     R13: 90135c78b99e07f5  R14: 0000000000000200  R15: ffff9119994b4620
>>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>>  #7 [ffffac308ec4fd90] bch_btree_node_read at ffffffffc06c6867 [escache]
>>  #8 [ffffac308ec4fe10] btree_node_prefetch at ffffffffc06c77ae [escache]
>>  #9 [ffffac308ec4fe28] bch_btree_check_thread at ffffffffc06c881c 
>> [escache]
>> #10 [ffffac308ec4ff10] kthread at ffffffffb8cd3542
>> #11 [ffffac308ec4ff50] ret_from_fork at ffffffffb9600255
>> crash> l *0xffffffffc06c6867
>> 0xffffffffc06c6867 is in bch_btree_node_read 
>> (drivers/md/bcache/btree.c:271).
>> 266
>> 267             if (btree_node_io_error(b))
>> 268                     goto err;
>> 269
>> 270             bch_btree_node_read_done(b);
>> 271 bch_time_stats_update(&b->c->btree_read_time, start_time);
>> 272
>> 273             return;
>> 274     err:
>> 275             bch_cache_set_error(b->c, "io error reading bucket %zu",
>>
>>
>> I think the b->c maybe is the NULL pointer.
>>
> I found the addresses of b and b->c by disassemble:
>
> crash> struct btree.c 0xffff911f090f7000
>
>   c = 0xffff911fcac20000
> crash> struct btree.parent 0xffff911f090f7000
>   parent = 0xffff911f090f4c00
> crash> struct btree.c 0xffff911f090f4c00
>   c = 0xffff911fcac20000
> crash> struct btree.parent 0xffff911f090f4c00
>   parent = 0x0
> crash> struct cache_set 0xffff911fcac20000
> struct cache_set struct: page excluded: kernel virtual address: 
> ffff911fcac20000  type: "gdb_readmem_callback"
> Cannot access memory at address 0xffff911fcac20000

I see. Yes we need to explicitly wait for all async ckecker to complete, 
before going into the error handling code path.


This patch looks fine to me. I added it in my testing queue already.  
Thank you for the fix up :-)


Coly Li

