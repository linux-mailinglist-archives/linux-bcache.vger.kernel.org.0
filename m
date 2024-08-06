Return-Path: <linux-bcache+bounces-709-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B24B949485
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Aug 2024 17:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6F6E289AE0
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Aug 2024 15:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03BDF1DDEA;
	Tue,  6 Aug 2024 15:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="hKwGlJTS"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4C8433A2
	for <linux-bcache@vger.kernel.org>; Tue,  6 Aug 2024 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722958004; cv=none; b=GhKUajHceQtm2GOhpcSjhqGjqQnQ08l6kW76GqxKpE3eE9HgzI1QtmtctF9VXwjMub2AmIvqqZUpXLZY0JsparTuR4fP4XnVlbxz2eOr6NCMjo2sqq8iwaL3rkt81hKNVBDgvnaBZZRi2yhwIDn3kA/X705oZ48IyPj/wod4Dm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722958004; c=relaxed/simple;
	bh=bbI7zAOLkouBtklcLDGLnQq1Wh0s8OlMEJx3b/YBHrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hwrk4pg+iT5X9olv4wZuxrMDIjQJMkLv74tyKsoVObFv0FwSy5mJm8vg0XgSMtoKxso/W1SYuSXOkjxDH/QtV6HldWdECw0LTXJ4gFR/1Wzfanm3/uQqEDtFr4xfUOTbQsEfDY6BM9JgJPhegLFeBWnT9X/AlKKdmxtizIhILnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=hKwGlJTS; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52efa9500e0so1042318e87.3
        for <linux-bcache@vger.kernel.org>; Tue, 06 Aug 2024 08:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1722958001; x=1723562801; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6OyOXDm3ZG7owKAricHALUnw3ZvEBDPAkTjO7DUhk28=;
        b=hKwGlJTSYiKvcyoaC5g2hqbuw81tgf5Nrkdg5tzMqpgq9asXfgJsFBalmQFB6rDx4l
         /kqrr45dS9/gmgud1e1TLj/3KrqwfhjVYwahD1IMtqd176ZLKZPJ8wEXbWsI5gCjH+kD
         AfQAq/UEDxXWjBZ4HzZeCX4FEZIu3o10fKAbQ/8SdZeWemOdzZYjicN7gQyJtT/SQK6U
         XfPQ1q05MdyWWulp1qWwSndwC7TVjx75e3JCYhfV+ezT+3/TfAPPuxO4R6CTq+AOm9EA
         ZYAXFazBfxugCY6SD/7baxXHcjgkTyFUWPriJuCoMGbhtZILGIEX7q5cPeSr2Fb96fxi
         CgEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722958001; x=1723562801;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6OyOXDm3ZG7owKAricHALUnw3ZvEBDPAkTjO7DUhk28=;
        b=UqLDRmzSCjx1CyBlLpAuPDElHZYjzdG79+Rr0+7FqObxzr2ycMUP/8S7oqHc5M9RPW
         V15vVuEEuJ/AvgOmL+tjSs212yuFHGoUwdeqvtt5qnpW4dzU/rVC7X9KQNkj9uB9flCM
         QODclfnFlolnvqrhCvCbkF1uc0dDVi6hodZozyBW9t5R5D+tImr5gt/BhfQ/cMf3+Um1
         gwD29KcCxp0UojMjNpGRTYfFkqPZnhp2zt1bvKwo5a85os4mLqCQFNnc3rAi3U034lGp
         GUEiT5ZQ4E5dsr7WNNGNLXVRhyDyFlQvnjHvODVJHEdKjrW/o7HGKxNu5MQD9xhQuORd
         cbSg==
X-Gm-Message-State: AOJu0Yxo8HuAQsGqAh0xIMgffdOXEqDOXc8JaE3kf9zZPO/vltoiSn+y
	YKIWuPPZsXZzW0mVvrllNep6LADHO0lcxKoYXCTR7TLBELXC1Q6oHPLlcp9ZUXE=
X-Google-Smtp-Source: AGHT+IHbJdsXDDhA8yxvDSzq2EUJCn54iLnuC3JA7fCeMhcBzo9dIEKTtVzu8KmP/YjBsSGFvt1Pag==
X-Received: by 2002:a05:6512:1083:b0:530:ab72:25ea with SMTP id 2adb3069b0e04-530bb379bf6mr9461954e87.28.1722958000233;
        Tue, 06 Aug 2024 08:26:40 -0700 (PDT)
Received: from [10.8.7.139] ([84.252.147.250])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-530bba33aedsm1520314e87.193.2024.08.06.08.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Aug 2024 08:26:39 -0700 (PDT)
Message-ID: <98edf6e8-8b1d-4e35-803f-1a3ada4da39d@dubeyko.com>
Date: Tue, 6 Aug 2024 18:26:38 +0300
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bcachefs mount issue
To: Jonathan Carter <jcc@debian.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>, slava@dubeiko.com
References: <0D2287C8-F086-43B1-85FA-B672BFF908F5@dubeyko.com>
 <6l34ceq4gzigfv7dzrs7t4eo3tops7e5ryasdzv4fo5steponz@d5uqypjctrem>
 <21872462-7c7c-4320-9c46-7b34195b92de@debian.org>
Content-Language: en-US
From: Viacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <21872462-7c7c-4320-9c46-7b34195b92de@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/6/24 12:21, Jonathan Carter wrote:
> Hi Kent
> 
> On 2024/08/06 09:50, Kent Overstreet wrote:
>> Debian hasn't been getting tools updates, you can't get anything modern
>> because of, I believe, a libsodium transition (?), and modern 1.9.x
>> versions aren't getting pushed out either.
>>
>> I'll have to refer you to them - Jonathan, what's going on?
> 
> 1.9.1 is in unstable. 1.9.4 would be good to go if it wasn't for a build 
> failure I haven't had time to figure out, although I e-mailed you about 
> it on the 26th (Message-ID: 
> <2250a9ef-39e0-4afc-8d0d-2d26fbddbdaa@debian.org>) but haven't received 
> any reply yet.
> 
> Since the 26th I've also been at DebCamp/DebConf the last two weeks in 
> Korea, with way too many other things going on, but when I'm back home 
> after my travels I can also ask the Debian Rust team for some assistance 
> if you don't beat them to it.
> 

I cloned the bcachefs tools repository, compiled and installed it.
Now it works well.

sudo mkfs.bcachefs -f --block_size=4096 /dev/sda1
/dev/sda1 contains a nilfs2 filesystem
External UUID: 
62535e21-93b3-4081-9ccf-753c61cca7a6
Internal UUID: 
427209d9-a84b-4307-b47f-df3fb6256dca
Magic number: 
c68573f6-66ce-90a9-d96a-60cf803df7ef
Device index:                              0
Label:                                     (none)
Version:                                   1.7: mi_btree_bitmap
Version upgrade complete:                  0.0: (unknown version)
Oldest version on disk:                    1.7: mi_btree_bitmap
Created:                                   Tue Aug  6 18:15:24 2024
Sequence number:                           0
Time of last write:                        Thu Jan  1 03:00:00 1970
Superblock size:                           976 B/1.00 MiB
Clean:                                     0
Devices:                                   1
Sections:                                  members_v1,members_v2
Features:
Compat features:

Options:
   block_size:                              4.00 KiB
   btree_node_size:                         128 KiB
   errors:                                  continue [fix_safe] panic ro
   metadata_replicas:                       1
   data_replicas:                           1
   metadata_replicas_required:              1
   data_replicas_required:                  1
   encoded_extent_max:                      64.0 KiB
   metadata_checksum:                       none [crc32c] crc64 xxhash
   data_checksum:                           none [crc32c] crc64 xxhash
   compression:                             none
   background_compression:                  none
   str_hash:                                crc32c crc64 [siphash]
   metadata_target:                         none
   foreground_target:                       none
   background_target:                       none
   promote_target:                          none
   erasure_code:                            0
   inodes_32bit:                            1
   shard_inode_numbers:                     1
   inodes_use_key_cache:                    1
   gc_reserve_percent:                      8
   gc_reserve_bytes:                        0 B
   root_reserve_percent:                    0
   wide_macs:                               0
   acl:                                     1
   usrquota:                                0
   grpquota:                                0
   prjquota:                                0
   journal_flush_delay:                     1000
   journal_flush_disabled:                  0
   journal_reclaim_delay:                   100
   journal_transaction_names:               1
   version_upgrade:                         [compatible] incompatible none
   nocow:                                   0

members_v2 (size 160):
Device:                                    0
   Label:                                   (none)
   UUID: 
452c3323-22af-4031-9c0b-bcf3221cf48c
   Size:                                    953 MiB
   read errors:                             0
   write errors:                            0
   checksum errors:                         0
   seqread iops:                            0
   seqwrite iops:                           0
   randread iops:                           0
   randwrite iops:                          0
   Bucket size:                             128 KiB
   First bucket:                            0
   Buckets:                                 7624
   Last mount:                              (never)
   Last superblock write:                   0
   State:                                   rw
   Data allowed:                            journal,btree,user
   Has data:                                (none)
   Btree allocated bitmap blocksize:        1.00 B
   Btree allocated bitmap: 
0000000000000000000000000000000000000000000000000000000000000000
   Durability:                              1
   Discard:                                 0
   Freespace initialized:                   0

Thanks,
Slava.


