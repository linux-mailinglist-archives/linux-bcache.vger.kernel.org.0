Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFB87AB2A8
	for <lists+linux-bcache@lfdr.de>; Fri, 22 Sep 2023 15:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbjIVN05 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 22 Sep 2023 09:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjIVN04 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 22 Sep 2023 09:26:56 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B91E8
        for <linux-bcache@vger.kernel.org>; Fri, 22 Sep 2023 06:26:50 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-3214d4ecd39so1943131f8f.1
        for <linux-bcache@vger.kernel.org>; Fri, 22 Sep 2023 06:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google; t=1695389208; x=1695994008; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZWn5ggNt6EY70FhoHAAeJI8jKtyuG0tU9M6X1hxnIw=;
        b=VNyhEMlGgrK1Ii8wgxEefQeCcf27jWfkkwI6ZPVy/iSCl8zcvs3/qzL5X8LRYyAZA7
         PDyXyiX+xrUyEo5Hd+aH52u4IA6ibx39rcNY+qRmLS/6YXhWrK2OIIpXMot3u6QYlBS/
         F8gkQkp1/8PUs16iXB7/5WoHxppFcC6iEBjPY0L3VxuNEg2cnSbMl1PwB7YWA52xVcny
         xIpevPS0UCd4Ajgg/hk9/6fc63832FHJqBOZtKQQ8KXe2FxiOCBQ0LkPSEHtU5lvU5lc
         7cpCUjyJSv9KrCy6X6MTwmtUMpykqm529Y4GjbwMyGTkMNyKTowJ9wW+MDey2/foLbuO
         Bz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695389208; x=1695994008;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IZWn5ggNt6EY70FhoHAAeJI8jKtyuG0tU9M6X1hxnIw=;
        b=G6Sg+7glI5EmUnKZVxjniRwHHjk0zGAjTHmKv40k0UBvmGkXsVMpA8I23Ej7XGhSxE
         sAtInMLqg7F+vt6WkPTXGGqvv/zIEVyNYvgSNIdAGU6Oypo2JxlQNcHW4pUzAvaEWPlI
         8q/24WJAQ3utYLpQEKOA+H7fJiJH0hJ9K4Si07FCsgJg05oGvFnbM8Rdm1h78LgGdF+q
         nfQJvUTstGMIZ1JhWvKrRS8JlVGIvaA4cBH4Ulp9qu6dn0AEjXPXFVvtrEDunpWWeGIC
         dpEOk34fSrEFsVp6OQZ/E4k/NRNk8FXneooPuNDYIOY4DR8pgMsLt0ZlUtfzkstGklfd
         4d8w==
X-Gm-Message-State: AOJu0YxjzlhhUiRuoxiFVsXVz59h1k1C60/VlV1P3hm6DERTld4zaUi5
        GrBFJ4VWsLNfyRz4Htt8Vjmh0vKomz4ISYZrGGk8tA==
X-Google-Smtp-Source: AGHT+IETz4rQfEebdfzxtav8WJnyqqcIO5ODhmaBJCrcNc6vchjehHMHmwiiHYqpWhjq4WHmZrxMwg==
X-Received: by 2002:adf:e98c:0:b0:31f:f94f:e13f with SMTP id h12-20020adfe98c000000b0031ff94fe13fmr7536731wrm.19.1695389208542;
        Fri, 22 Sep 2023 06:26:48 -0700 (PDT)
Received: from [192.168.1.68] (37.238.14.37.dynamic.jazztel.es. [37.14.238.37])
        by smtp.gmail.com with ESMTPSA id g7-20020a5d46c7000000b0031fbbe347e1sm4493935wrs.65.2023.09.22.06.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 06:26:48 -0700 (PDT)
Message-ID: <4fd61b55-195f-8dc5-598e-835bd03a00ec@devo.com>
Date:   Fri, 22 Sep 2023 15:26:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Subject: Unusual value of optimal_io_size prevents bcache initialization
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,
recently I was testing bcache on new HW when, while creating a bcache 
device with make-bcache -B /dev/nvme16n1, I got this kernel WARNING:

------------[ cut here ]------------
WARNING: CPU: 41 PID: 648 at mm/util.c:630 kvmalloc_node+0x12c/0x178
Modules linked in: nf_conntrack_netlink nf_conntrack nf_defrag_ipv6 
nf_defrag_ipv4 nfnetlink_acct wireguard libchacha20poly1305 chacha_neon 
poly1305_neon ip6_udp_tunnel udp_tunnel libcurve25519_generic libchacha 
nfnetlink ip6table_filter ip6_tables iptable_filter bpfilter 
nls_iso8859_1 xfs libcrc32c dm_multipath scsi_dh_rdac scsi_dh_emc 
scsi_dh_alua bcache crc64 raid0 aes_ce_blk crypto_simd cryptd 
aes_ce_cipher crct10dif_ce ghash_ce sha2_ce sha256_arm64 ena sha1_ce 
sch_fq_codel drm efi_pstore ip_tables x_tables autofs4
CPU: 41 PID: 648 Comm: kworker/41:2 Not tainted 5.15.0-1039-aws 
#44~20.04.1-Ubuntu
Hardware name: DEVO new fabulous hardware/, BIOS 1.0 11/1/2018
Workqueue: events register_bdev_worker [bcache]
pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : kvmalloc_node+0x12c/0x178
lr : kvmalloc_node+0x74/0x178
sp : ffff80000ea4bc90
x29: ffff80000ea4bc90 x28: ffffdfa18f249c70 x27: ffff0003c9690000
x26: ffff00043160e8e8 x25: ffff000431600040 x24: ffffdfa18f249ec0
x23: ffff0003c1d176c0 x22: 00000000ffffffff x21: ffffdfa18f236938
x20: 00000000833ffff8 x19: 0000000000000dc0 x18: 0000000000000000
x17: ffff20de6376c000 x16: ffffdfa19df02f48 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000000 x9 : ffffdfa19df8d468
x8 : ffff00043160e800 x7 : 0000000000000010 x6 : 000000000000c8c8
x5 : 00000000ffffffff x4 : 0000000000012dc0 x3 : 0000000100000000
x2 : 00000000833ffff8 x1 : 000000007fffffff x0 : 0000000000000000
Call trace:
  kvmalloc_node+0x12c/0x178
  bcache_device_init+0x80/0x2e8 [bcache]
  register_bdev_worker+0x228/0x450 [bcache]
  process_one_work+0x200/0x4d8
  worker_thread+0x148/0x558
  kthread+0x114/0x120
  ret_from_fork+0x10/0x20
---[ end trace e326483a1d681714 ]---
bcache: register_bdev() error nvme16n1: cannot allocate memory
bcache: register_bdev_worker() error /dev/nvme16n1: fail to register 
backing device
bcache: bcache_device_free() bcache device (NULL gendisk) stopped

I tracked down the root cause: in this new HW the disks have an 
optimal_io_size of 4096. Doing some maths, it's easy to find out that 
this makes bcache initialization fails for all the backing disks greater 
than 2 TiB. Is this a well-known limitation?

Analyzing bcache_device_init I came up with a doubt:
...
	n = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
	if (!n || n > max_stripes) {
		pr_err("nr_stripes too large or invalid: %llu (start sector beyond end 
of disk?)\n",
			n);
		return -ENOMEM;
	}
	d->nr_stripes = n;

	n = d->nr_stripes * sizeof(atomic_t);
	d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
...
Is it normal that n is been checked against max_stripes _before_ its 
value gets changed by a multiply it by sizeof(atomic_t) ? Shouldn't the 
check happen just before trying to kvzalloc n?

Another consideration, stripe_sectors_dirty and full_dirty_stripes, the 
two arrays allocated using n, are being used just in writeback mode, is 
this correct? In my specific case, I'm not planning to use writeback 
mode so I would expect bcache to not even try to create those arrays. 
Or, at least, to not create them during initialization but just in case 
of a change in the working mode (i.e. write-through -> writeback).

Best regards,
Andrea
