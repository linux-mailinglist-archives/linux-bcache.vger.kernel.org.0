Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E827BEF4B
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Oct 2023 01:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377588AbjJIXoQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Oct 2023 19:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377918AbjJIXoP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Oct 2023 19:44:15 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040E8AC
        for <linux-bcache@vger.kernel.org>; Mon,  9 Oct 2023 16:44:12 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-534659061afso8413735a12.3
        for <linux-bcache@vger.kernel.org>; Mon, 09 Oct 2023 16:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1696895050; x=1697499850; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S1Sf9TKUT2/NlM+VJDRsKY9XdVMM2olJd2mdJBg22ic=;
        b=PW/SYy14F2ou9XuO5ricqymxN8TtaMGyjnkHBRQFFF0I9oyi9Rr9e+W+DmbOqWrYg/
         lrDTkJq75mjAGBOu4dbynIHgq4BwlV2nOOwbMJDpRAGlJ4XeVfNgKB3AzhFyHzpLn785
         QgPx97DLDUPkHQAHkejqFAHARDUJZZ5+lPejU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696895050; x=1697499850;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S1Sf9TKUT2/NlM+VJDRsKY9XdVMM2olJd2mdJBg22ic=;
        b=L3lQFxHXDKJPOuJQnG33uMDnWKZexih7a8J/P3SvM5cYF3Wv6L0NT6yEThtjJVeOEK
         nHTsTFXVKoU40GXug7joURF8bHQk+SPtjHKuwcYSieeFVDsNTE2YClryUS1wqJlOyGgb
         W9L8oidCmAHI8F2nOMl72oQpBIjpewO3O+zkCKGAUP+Q1ccj8GfBzmuK5Fei47SFg51a
         N6COSYcxP3Zq8e6FgHKgryvMWsvP1AHxATXX6kq13Y0xlWtDL6Ea7OpuIl0cOKqZsW8k
         EE4rHFQ/7TLrOvz7BADJ+3p7gNMOvD+6H2o9uIWQlUtSl16HgbPaOG3atvh0VJH2Dz0r
         Oqww==
X-Gm-Message-State: AOJu0YwsWFMEMPmindVQ5E+sw25HzKP7kpHUBqlHF+bmqVksmbU3P9t1
        s6U+UHjvEsqKtk9HmlW/4GKGpzsRLkCoAFT7bg3ueFgR2WHRhkAEOlTpOQ==
X-Google-Smtp-Source: AGHT+IHfK/vH2j3nAF2ARhOjZFSPqGcVYOTkeq9DT7sPPAqrA7gjQdBKq5sY/SL+pR6lrke7FBd0NbzdcHxtKPDBQXw=
X-Received: by 2002:a05:6402:14c7:b0:51d:f5bd:5a88 with SMTP id
 f7-20020a05640214c700b0051df5bd5a88mr14859855edx.38.1696895049713; Mon, 09
 Oct 2023 16:44:09 -0700 (PDT)
MIME-Version: 1.0
From:   Daniel J Blueman <daniel@quora.org>
Date:   Tue, 10 Oct 2023 07:43:58 +0800
Message-ID: <CAMVG2sun2sqFXt=H-0cVWnATGMMFpe-0ksRWy3uhUZXbA5m1qA@mail.gmail.com>
Subject: trans path overflow during metadata replication with lockdep
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Firstly, bcachefs introduces a new era of in-tree filesystems with
some monumental features (sorry, ZFS); hats off to Kent for landing
this!

My testing finds it is in great shape; far better than BTRFS was when
it landed. Testing on linux next-20231005 with additional debug checks
atop the Ubuntu 23.04 kernel generic config [1], I was able to provoke
a btree trans path overflow cornercase [2].

The minimal reproducer is:
# modprobe brd rd_nr=2 rd_size=1048576
# bcachefs format --metadata_replicas=2 --label=tier1.1 /dev/ram0
--label=tier1.2 /dev/ram1
# mount -t bcachefs /dev/ram0:/dev/ram1 /mnt
# dd if=/dev/zero of=/mnt/test bs=128M

The issue doesn't reproduce with metadata_replicas=1 or a single block device.

At debug entry, I couldn't determine why BTREE_ITER_MAX must be 64
rather than 32 when CONFIG_LOCKDEP is set, however the panic doesn't
occur without CONFIG_LOCKDEP, so it appears related; keeping it at
value 32 with CONFIG_LOCKDEP doesn't prevent the panic also.

@Kent/anyone?

Thanks,
  Daniel

-- [1] https://quora.org/linux-next-20231005.config

-- [2]

[  493.761988] path: idx  4 ref 1:1 P S btree=alloc l=0 pos 0:98:0
locks 2 flush_new_cached_update+0x9f/0x390
[  493.762036] path: idx  7 ref 1:1 P S btree=alloc l=0 pos 0:300:0
locks 2 flush_new_cached_update+0x9f/0x390
[  493.762049] path: idx 11 ref 1:1 P S btree=alloc l=0 pos 0:581:0
locks 2 flush_new_cached_update+0x9f/0x390
[  493.762062] path: idx  5 ref 1:1 P S btree=alloc l=0 pos 1:98:0
locks 2 flush_new_cached_update+0x9f/0x390
[  493.762075] path: idx  9 ref 1:1 P S btree=alloc l=0 pos 1:300:0
locks 2 flush_new_cached_update+0x9f/0x390
[  493.762087] path: idx 13 ref 1:1 P S bt] path: idx  3 ref 1:1 P S
btree=alloc l=0 pos 0:98:0 locks 2
bch2_trans_start_alloc_update+0xf2/0x320
[  493.762125] path: idx  6 ref 1:1 P S btree=alloc l=0 pos 0:300:0
locks 2 bch2_trans_start_alloc_update+0xf2/0x320
[  493.762138] path: idx 10 ref 1:1 P S btree=alloc l=0 pos 0:581:0
locks 2 bch2_trans_start_alloc_update+0xf2/0x320
[  493.762151] path: idx  2 ref 1:1 P S btree=alloc l=0 pos 1:96:0
locks 2 bch2_trans_start_alloc_update+0xf2/0x320
[  493.762163] path: idx  1 ref 1:1 P S btree=alloc l=0 pos 1:98:0
locks 2 bch2_trans_start_alloc_update+0xf2/0x320
[  493.762176] path: idx  8 ref 1:1 P S btree=alloc l=0 pos 1:300:0
locks 2 bch2_trans_start_alloc_update+0xf2/0x320
[  493.762189] path: idx 12 ref 1:1 P S btree=alloc l=0 pos 1:581:0
locks 2 bch2_trans_start_alloc_update+0xf2/0x320
[  493.762201] path: idx 18 ref 0:0 P S btree=freespace l=0 pos 0:98:0
locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762214] path: idx 31 ref 1:1   S btree=freespace l=0 pos 0:99:0
locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762227] path: idx 19 ref 0:0     btree=freespace l=0 pos 0:99:0
locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762239] path: idx 20 ref 0:0     btree=freespace l=0 pos
0:300:0 locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762252] path: idx 21 ref 0:0     btree=freespace l=0 pos
0:301:0 locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762264] path: idx 22 ref 0:0     btree=freespace l=0 pos
0:581:0 locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762277] path: idx 24 ref 0:0     btree=freespace l=0 pos
0:582:0 locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762290] path: idx 29 ref 0:0     btree=freespace l=0 pos
0:589:0 locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762302] path: idx 23 ref 0:0     btree=freespace l=0 pos 1:98:0
locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762315] path: idx 25 ref 0:0     btree=freespace l=0 pos 1:99:0
locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762328] path: idx 26 ref 0:0     btree=freespace l=0 pos
1:300:0 locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762340] path: idx 27 ref 0:0     btree=freespace l=0 pos
1:301:0 locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762353] path: idx 28 ref 0:0     btree=freespace l=0 pos
1:581:0 locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762365] path: idx 30 ref 0:0     btree=freespace l=0 pos
1:582:0 locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762378] path: idx 14 ref 1:1 P S btree=need_discard l=0 pos
0:96:0 locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762391] path: idx 16 ref 1:1 P S btree=need_discard l=0 pos
1:96:0 locks 2 bch2_bucket_do_index+0x429/0x770
[  493.762403] path: idx 15 ref 1:1 P S btree=bucket_gens l=0 pos
POS_MIN locks 2 bch2_bucket_gen_update+0x19e/0x540
[  493.762416] path: idx 17 ref 1:1 P S btree=bucket_gens l=0 pos
1:0:0 locks 2 bch2_bucket_gen_update+0x19e/0x540
[  493.762429] transaction updates for btree_update_nodes_written journal seq 0
[  493.762441]   update: btree=alloc cached=0
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.762453]     old u64s 5 type deleted 0:98:0 len 0 ver 0
[  493.762464]     new u64s 12 type alloc_v4 0:98:0 len 0 ver 0:
[  493.762476]     gen 0 oldest_gen 0 data_type btree
[  493.762487]     journal_seq       0
[  493.762498]     need_discard      1
[  493.762509]     need_inc_gen      1
[  493.762521]     dirty_sectors     256
[  493.762532]     cached_sectors    0
[  493.762543]     stripe            0
[  493.762554]     stripe_redundancy 0
[  493.762565]     io_time[READ]     1
[  493.762576]     io_time[WRITE]    259160
[  493.762587]     fragmentation     0
[  493.762598]     bp_start          7
[  493.762609]
[  493.762619]   update: btree=alloc cached=0
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.762632]     old u64s 5 type deleted 0:300:0 len 0 ver 0
[  493.762643]     new u64s 12 type alloc_v4 0:300:0 len 0 ver 0:
[  493.762655]     gen 0 oldest_gen 0 data_type btree
[  493.762666]     journal_seq       0
[  493.762677]     need_discard      0
[  493.762688]     need_inc_gen      0
[  493.762699]     dirty_sectors     256
[  493.762710]     cached_sectors    0
[  493.762721]     stripe            0
[  493.762733]     stripe_redundancy 0
[  493.762744]     io_time[READ]     0
[  493.762755]     io_time[WRITE]    0
[  493.762766]     fragmentation     0
[  493.762777]     bp_start          7
[  493.762788]
[  493.762798]   update: btree=alloc cached=0
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.762810]     old u64s 5 type deleted 0:581:0 len 0 ver 0
[  493.762822]     new u64s 12 type alloc_v4 0:581:0 len 0 ver 0:
[  493.762834]     gen 0 oldest_gen 0 data_type btree
[  493.762845]     journal_seq       0
[  493.762856]     need_discard      0
[  493.762867]     need_inc_gen      0
[  493.762878]     dirty_sectors     256
[  493.762889]     cached_sectors    0
[  493.762900]     stripe            0
[  493.762911]     stripe_redundancy 0
[  493.762922]     io_time[READ]     0
[  493.762933]     io_time[WRITE]    0
[  493.762944]     fragmentation     0
[  493.762955]     bp_start          7
[  493.762966]
[  493.762977]   update: btree=alloc cached=0
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.762989]     old u64s 5 type deleted 1:98:0 len 0 ver 0
[  493.763001]     new u64s 12 type alloc_v4 1:98:0 len 0 ver 0:
[  493.763012]     gen 0 oldest_gen 0 data_type btree
[  493.763024]     journal_seq       0
[  493.763035]     need_discard      0
[  493.763046]     need_inc_gen      0
[  493.763057]     dirty_sectors     256
[  493.763068]     cached_sectors    0
[  493.763079]     stripe            0
[  493.763090]     stripe_redundancy 0
[  493.763101]     io_time[READ]     0
[  493.763112]     io_time[WRITE]    0
[  493.763123]     fragmentation     0
[  493.763134]     bp_start          7
[  493.763145]
[  493.763156]   update: btree=alloc cached=0
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.763168]     old u64s 5 type deleted 1:300:0 len 0 ver 0
[  493.763179]     new u64s 12 type alloc_v4 1:300:0 len 0 ver 0:
[  493.763191]     gen 0 oldest_gen 0 data_type btree
[  493.763202]     journal_seq       0
[  493.763214]     need_discard      0
[  493.763225]     need_inc_gen      0
[  493.763236]     dirty_sectors     256
[  493.763247]     cached_sectors    0
[  493.763258]     stripe            0
[  493.763269]     stripe_redundancy 0
[  493.763280]     io_time[READ]     0
[  493.763291]     io_time[WRITE]    0
[  493.763302]     fragmentation     0
[  493.763313]     bp_start          7
[  493.763324]
[  493.763334]   update: btree=alloc cached=0
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.763347]     old u64s 5 type deleted 1:581:0 len 0 ver 0
[  493.763358]     new u64s 12 type alloc_v4 1:581:0 len 0 ver 0:
[  493.763370]     gen 0 oldest_gen 0 data_type btree
[  493.763381]     journal_seq       0
[  493.763392]     need_discard      0
[  493.763403]     need_inc_gen      0
[  493.763414]     dirty_sectors     256
[  493.763425]     cached_sectors    0
[  493.763436]     stripe            0
[  493.763447]     stripe_redundancy 0
[  493.763458]     io_time[READ]     0
[  493.763469]     io_time[WRITE]    0
[  493.763480]     fragmentation     0
[  493.763492]     bp_start          7
[  493.763503]
[  493.763513]   update: btree=alloc cached=1
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.763525]     old u64s 12 type alloc_v4 0:96:0 len 0 ver 0:
[  493.763537]     gen 0 oldest_gen 0 data_type btree
[  493.763548]     journal_seq       5
[  493.763559]     need_discard      1
[  493.763570]     need_inc_gen      1
[  493.763581]     dirty_sectors     256
[  493.763593]     cached_sectors    0
[  493.763604]     stripe            0
[  493.763615]     stripe_redundancy 0
[  493.763626]     io_time[READ]     1
[  493.763637]     io_time[WRITE]    8424
[  493.763648]     fragmentation     0
[  493.763659]     bp_start          7
[  493.763670]
[  493.763680]     new u64s 12 type alloc_v4 0:96:0 len 0 ver 0:
[  493.763692]     gen 1 oldest_gen 0 data_type need_discard
[  493.763703]     journal_seq       5
[  493.763714]     need_discard      1
[  493.763726]     need_inc_gen      0
[  493.763737]     dirty_sectors     0
[  493.763748]     cached_sectors    0
[  493.763759]     stripe            0
[  493.763770]     stripe_redundancy 0
[  493.763781]     io_time[READ]     1
[  493.763792]     io_time[WRITE]    8424
[  493.763803]     fragmentation     0
[  493.763814]     bp_start          7
[  493.763825]
[  493.763835]   update: btree=alloc cached=1
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.763848]     old u64s 5 type deleted 0:98:0 len 0 ver 0
[  493.763859]     new u64s 12 type alloc_v4 0:98:0 len 0 ver 0:
[  493.763871]     gen 0 oldest_gen 0 data_type btree
[  493.763882]     journal_seq       0
[  493.763893]     need_discard      1
[  493.763904]     need_inc_gen      1
[  493.763915]     dirty_sectors     256
[  493.763926]     cached_sectors    0
[  493.763937]     stripe            0
[  493.763948]     stripe_redundancy 0
[  493.763959]     io_time[READ]     1
[  493.763970]     io_time[WRITE]    259160
[  493.763982]     fragmentation     0
[  493.763993]     bp_start          7
[  493.764004]
[  493.764014]   update: btree=alloc cached=1
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.764026]     old u64s 5 type deleted 0:300:0 len 0 ver 0
[  493.764038]     new u64s 12 type alloc_v4 0:300:0 len 0 ver 0:
[  493.764050]     gen 0 oldest_gen 0 data_type btree
[  493.764061]     journal_seq       0
[  493.764072]     need_discard      0
[  493.764083]     need_inc_gen      0
[  493.764094]     dirty_sectors     256
[  493.764105]     cached_sectors    0
[  493.764116]     stripe            0
[  493.764127]     stripe_redundancy 0
[  493.764138]     io_time[READ]     0
[  493.764149]     io_time[WRITE]    0
[  493.764160]     fragmentation     0
[  493.764171]     bp_start          7
[  493.764182]
[  493.764193]   update: btree=alloc cached=1
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.764205]     old u64s 5 type deleted 0:581:0 len 0 ver 0
[  493.764217]     new u64s 12 type alloc_v4 0:581:0 len 0 ver 0:
[  493.764228]     gen 0 oldest_gen 0 data_type btree
[  493.764240]     journal_seq       0
[  493.764251]     need_discard      0
[  493.764262]     need_inc_gen      0
[  493.764273]     dirty_sectors     256
[  493.764284]     cached_sectors    0
[  493.764295]     stripe            0
[  493.764306]     stripe_redundancy 0
[  493.764317]     io_time[READ]     0
[  493.764328]     io_time[WRITE]    0
[  493.764339]     fragmentation     0
[  493.764350]     bp_start          7
[  493.764361]
[  493.764371]   update: btree=alloc cached=1
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.764384]     old u64s 12 type alloc_v4 1:96:0 len 0 ver 0:
[  493.764395]     gen 0 oldest_gen 0 data_type btree
[  493.764407]     journal_seq       5
[  493.764418]     need_discard      1
[  493.764429]     need_inc_gen      1
[  493.764440]     dirty_sectors     256
[  493.764451]     cached_sectors    0
[  493.764462]     stripe            0
[  493.764473]     stripe_redundancy 0
[  493.764484]     io_time[READ]     1
[  493.764495]     io_time[WRITE]    8424
[  493.764506]     fragmentation     0
[  493.764517]     bp_start          7
[  493.764528]
[  493.764539]     new u64s 12 type alloc_v4 1:96:0 len 0 ver 0:
[  493.764550]     gen 1 oldest_gen 0 data_type need_discard
[  493.764562]     journal_seq       5
[  493.764573]     need_discard      1
[  493.764584]     need_inc_gen      0
[  493.764595]     dirty_sectors     0
[  493.764606]     cached_sectors    0
[  493.764617]     stripe            0
[  493.764628]     stripe_redundancy 0
[  493.764639]     io_time[READ]     1
[  493.764650]     io_time[WRITE]    8424
[  493.764661]     fragmentation     0
[  493.764672]     bp_start          7
[  493.764683]
[  493.764694]   update: btree=alloc cached=1
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.764706]     old u64s 5 type deleted 1:98:0 len 0 ver 0
[  493.764717]     new u64s 12 type alloc_v4 1:98:0 len 0 ver 0:
[  493.764729]     gen 0 oldest_gen 0 data_type btree
[  493.764740]     journal_seq       0
[  493.764804]     need_discard      0
[  493.764815]     need_inc_gen      0
[  493.764827]     dirty_sectors     256
[  493.764838]     cached_sectors    0
[  493.764849]     stripe            0
[  493.764860]     stripe_redundancy 0
[  493.764871]     io_time[READ]     0
[  493.764882]     io_time[WRITE]    0
[  493.764893]     fragmentation     0
[  493.764904]     bp_start          7
[  493.764915]
[  493.764925]   update: btree=alloc cached=1
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.764938]     old u64s 5 type deleted 1:300:0 len 0 ver 0
[  493.764949]     new u64s 12 type alloc_v4 1:300:0 len 0 ver 0:
[  493.764961]     gen 0 oldest_gen 0 data_type btree
[  493.764972]     journal_seq       0
[  493.764983]     need_discard      0
[  493.764994]     need_inc_gen      0
[  493.765005]     dirty_sectors     256
[  493.765016]     cached_sectors    0
[  493.765027]     stripe            0
[  493.765038]     stripe_redundancy 0
[  493.765049]     io_time[READ]     0
[  493.765060]     io_time[WRITE]    0
[  493.765071]     fragmentation     0
[  493.765082]     bp_start          7
[  493.765093]
[  493.765104]   update: btree=alloc cached=1
bch2_trans_mark_pointer.constprop.0+0x532/0xbf0
[  493.765116]     old u64s 5 type deleted 1:581:0 len 0 ver 0
[  493.765128]     new u64s 12 type alloc_v4 1:581:0 len 0 ver 0:
[  493.765139]     gen 0 oldest_gen 0 data_type btree
[  493.765151]     journal_seq       0
[  493.765162]     need_discard      0
[  493.765173]     need_inc_gen      0
[  493.765184]     dirty_sectors     256
[  493.765195]     cached_sectors    0
[  493.765206]     stripe            0
[  493.765217]     stripe_redundancy 0
[  493.765228]     io_time[READ]     0
[  493.765239]     io_time[WRITE]    0
[  493.765250]     fragmentation     0
[  493.765261]     bp_start          7
[  493.765272]
[  493.765283]   update: btree=need_discard cached=0
bch2_bucket_do_index+0x4ba/0x770
[  493.765295]     old u64s 5 type deleted 0:96:0 len 0 ver 0
[  493.765307]     new u64s 5 type set 0:96:0 len 0 ver 0
[  493.765318]   update: btree=need_discard cached=0
bch2_bucket_do_index+0x4ba/0x770
[  493.765330]     old u64s 5 type deleted 1:96:0 len 0 ver 0
[  493.765342]     new u64s 5 type set 1:96:0 len 0 ver 0
[  493.765353]   update: btree=bucket_gens cached=0
bch2_bucket_gen_update+0x3ce/0x540
[  493.765365]     old u64s 5 type deleted POS_MIN len 0 ver 0
[  493.765377]     new u64s 37 type bucket_gens POS_MIN len 0 ver 0: 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
[  493.765399]   update: btree=bucket_gens cached=0
bch2_bucket_gen_update+0x3ce/0x540
[  493.765412]     old u64s 5 type deleted 1:0:0 len 0 ver 0
[  493.765423]     new u64s 37 type bucket_gens 1:0:0 len 0 ver 0: 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0
[  493.765446]   update: btree=backpointers wb=1
bch2_btree_insert_nonextent+0x164/0x170
[  493.765458]     new u64s 5 type deleted 0:25165824:0 len 0 ver 0
[  493.765470]   update: btree=backpointers wb=1
bch2_btree_insert_nonextent+0x164/0x170
[  493.765482]     new u64s 5 type deleted 1:25165824:0 len 0 ver 0
[  493.765494]   update: btree=backpointers wb=1
bch2_btree_insert_nonextent+0x164/0x170
[  493.765506]     new u64s 9 type backpointer 0:25690112:0 len 0 ver
0: bucket=0:98:0 btree=extents l=1 offset=0:0 len=256
pos=671088640:149504:U32_MAX
[  493.765519]   update: btree=backpointers wb=1
bch2_btree_insert_nonextent+0x164/0x170
[  493.765531]     new u64s 9 type backpointer 1:25690112:0 len 0 ver
0: bucket=1:98:0 btree=extents l=1 offset=0:0 len=256
pos=671088640:149504:U32_MAX
[  493.765545]   update: btree=backpointers wb=1
bch2_btree_insert_nonextent+0x164/0x170
[  493.765557]     new u64s 9 type backpointer 0:78643200:0 len 0 ver
0: bucket=0:300:0 btree=extents l=1 offset=0:0 len=256 pos=SPOS_MAX
[  493.765570]   update: btree=backpointers wb=1
bch2_btree_insert_nonextent+0x164/0x170
[  493.765582]     new u64s 9 type backpointer 1:78643200:0 len 0 ver
0: bucket=1:300:0 btree=extents l=1 offset=0:0 len=256 pos=SPOS_MAX
[  493.765595]   update: btree=backpointers wb=1
bch2_btree_insert_nonextent+0x164/0x170
[  493.765608]     new u64s 9 type backpointer 0:152305664:0 len 0 ver
0: bucket=0:581:0 btree=extents l=2 offset=0:0 len=256 pos=SPOS_MAX
[  493.765622]   update: btree=backpointers wb=1
bch2_btree_insert_nonextent+0x164/0x170
[  493.765634]     new u64s 9 type backpointer 1:152305664:0 len 0 ver
0: bucket=1:581:0 btree=extents l=2 offset=0:0 len=256 pos=SPOS_MAX
[  493.765648]
[  496.612047] Kernel panic - not syncing: trans path overflow
[  496.626162] CPU: 18 PID: 11 Comm: kworker/u96:0 Not tainted
6.6.0-rc4-next-20231005 #3
[  496.642928] Hardware name: Supermicro AS -3014TS-i/H12SSL-i, BIOS
2.5 09/08/2022
[  496.659120] Workqueue: btree_update btree_interior_update_work
[  496.673783] Call Trace:
[  496.684799]  <TASK>
[  496.695345]  dump_stack_lvl+0x5f/0xc0
[  496.707528]  dump_stack+0x10/0x20
[  496.719236]  panic+0x444/0x4b0
[  496.730566]  ? kfree+0x12a/0x150
[  496.742073]  ? __pfx_panic+0x10/0x10
[  496.753841]  ? srso_alias_return_thunk+0x5/0xfbef5
[  496.766816]  ? __bch2_dump_trans_paths_updates+0xda/0x120
[  496.780289]  ? __pfx_bch2_btree_path_verify_level+0x10/0x10
[  496.793999]  btree_path_overflow+0x1f/0x20
[  496.806119]  __bch2_btree_path_make_mut+0x6e8/0x840
[  496.819146]  ? srso_alias_return_thunk+0x5/0xfbef5
[  496.832005]  ? btree_trans_verify_sorted_refs+0x263/0x340
[  496.845475]  ? __asan_storeN+0x12/0x30
[  496.857128]  ? bch2_trans_update_extent.isra.0+0x17a/0x740
[  496.870432]  __bch2_btree_path_set_pos+0x1dc/0x7e0
[  496.882969]  ? srso_alias_return_thunk+0x5/0xfbef5
[  496.895575]  ? bch2_btree_path_verify+0xbd/0x1a0
[  496.908175]  bch2_btree_iter_peek_upto+0xb14/0x1d00
[  496.921066]  ? bch2_trans_update_extent.isra.0+0x17a/0x740
[  496.934381]  ? __pfx_bch2_btree_iter_peek_upto+0x10/0x10
[  496.947402]  ? bch2_trans_update_extent.isra.0+0x17a/0x740
[  496.960594]  ? bch2_trans_update_extent.isra.0+0x17a/0x740
[  496.973626]  ? __pfx_bch2_trans_iter_init_outlined+0x10/0x10
[  496.986793]  ? bch2_btree_path_verify_locks+0xe7/0x220
[  496.999311]  bch2_trans_update_extent.isra.0+0x1d3/0x740
[  497.011773]  ? bch2_trans_update_extent.isra.0+0x1d3/0x740
[  497.024430]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.036194]  ? __pfx_bch2_trans_update_extent.isra.0+0x10/0x10
[  497.048854]  ? __pfx_bch2_btree_iter_peek_slot+0x10/0x10
[  497.061036]  ? bch2_trans_update_extent.isra.0+0x17a/0x740
[  497.073114]  ? bch2_bucket_do_index+0x429/0x770
[  497.084016]  bch2_trans_update+0x1bd/0x210
[  497.094299]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.105155]  ? bch2_trans_update+0x1bd/0x210
[  497.115346]  bch2_bucket_do_index+0x4ba/0x770
[  497.125552]  ? __pfx_bch2_bucket_do_index+0x10/0x10
[  497.136144]  ? __pfx_bch2_bucket_gen_update+0x10/0x10
[  497.146625]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.156815]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.166824]  ? bch2_bucket_do_index+0x429/0x770
[  497.176301]  ? __asan_loadN+0xf/0x20
[  497.184765]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.194463]  ? bch2_btree_path_peek_slot+0x315/0x4a0
[  497.204342]  bch2_trans_mark_alloc+0x2e2/0x8d0
[  497.213532]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.223020]  ? bch2_trans_mark_alloc+0x2e2/0x8d0
[  497.232374]  ? __pfx_bch2_trans_mark_alloc+0x10/0x10
[  497.242097]  ? __pfx_verify_update_old_key+0x10/0x10
[  497.251873]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.261420]  ? bch2_btree_path_verify_locks+0xe7/0x220
[  497.271445]  run_btree_triggers+0x40b/0x7c0
[  497.280557]  ? __pfx_run_btree_triggers+0x10/0x10
[  497.290141]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.299876]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.309460]  ? bch2_replicas_entry_sort+0x66/0xd0
[  497.318999]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.328560]  ? update_replicas_list+0xc5/0xf0
[  497.337739]  __bch2_trans_commit+0x993/0x4200
[  497.346872]  ? __pfx_bch2_trans_mark_extent+0x10/0x10
[  497.356698]  ? __asan_storeN+0x12/0x30
[  497.365116]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.374735]  ? __pfx___bch2_trans_commit+0x10/0x10
[  497.384234]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.393722]  ? kasan_save_alloc_info+0x1e/0x40
[  497.402885]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.412373]  ? __kmalloc_node_track_caller+0x117/0x140
[  497.422218]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.431691]  ? rcu_is_watching+0x23/0x60
[  497.440253]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.449863]  btree_interior_update_work+0x1012/0x1460
[  497.459802]  ? __pfx_btree_interior_update_work+0x10/0x10
[  497.469986]  ? __pfx_lock_acquire+0x10/0x10
[  497.478878]  ? __pfx_lock_release+0x10/0x10
[  497.487667]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.497110]  ? process_one_work+0x3d6/0x950
[  497.505859]  ? process_one_work+0x3d1/0x950
[  497.514540]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.523856]  ? _raw_spin_unlock_irq+0x27/0x70
[  497.532767]  process_one_work+0x470/0x950
[  497.541347]  ? __pfx_process_one_work+0x10/0x10
[  497.550360]  ? do_raw_spin_lock+0x115/0x1d0
[  497.559088]  ? srso_alias_return_thunk+0x5/0xfbef5
[  497.568360]  ? assign_work+0xec/0x130
[  497.576490]  worker_thread+0x370/0x680
[  497.584774]  ? __pfx_worker_thread+0x10/0x10
[  497.593493]  kthread+0x1b3/0x200
[  497.601172]  ? kthread+0x103/0x200
[  497.609008]  ? __pfx_kthread+0x10/0x10
[  497.617208]  ret_from_fork+0x47/0x80
[  497.625178]  ? __pfx_kthread+0x10/0x10
[  497.633322]  ret_from_fork_asm+0x1b/0x30
[  497.641759]  </TASK>
[  497.649175] Kernel Offset: disabled
[  497.855603] ---[ end Kernel panic - not syncing: trans path overflow ]---
-- 
Daniel J Blueman
