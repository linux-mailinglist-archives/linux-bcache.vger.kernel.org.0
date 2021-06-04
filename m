Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6E439B793
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Jun 2021 13:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhFDLJh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Jun 2021 07:09:37 -0400
Received: from correo01.aragon.es ([188.244.81.25]:48294 "EHLO aragon.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229740AbhFDLJh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Jun 2021 07:09:37 -0400
Received: from aragon.es ([172.30.3.33])
        by FM2.aragon.es  with ESMTP id 154B7nP3025744-154B7nP4025744
        for <linux-bcache@vger.kernel.org>; Fri, 4 Jun 2021 13:07:49 +0200
Received: from [1.8.2.59] (account scastillo@aragon.es [1.8.2.59] verified)
  by aragon.es (CommuniGate Pro SMTP 6.2.12)
  with ESMTPSA id 92477807 for linux-bcache@vger.kernel.org; Fri, 04 Jun 2021 13:07:49 +0200
From:   Santiago Castillo Oli <scastillo@aragon.es>
Subject: Low hit ratio and cache usage
To:     linux-bcache@vger.kernel.org
Message-ID: <5b01087b-6e56-0396-774a-1c1a71fe50df@aragon.es>
Date:   Fri, 4 Jun 2021 13:07:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-FE-Policy-ID: 21:5:5:aragon.es
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi all!


I'm using bcache and I think I have a rather low hit ratio and cache 
occupation.


My setup is:

- Cache device: 82 GiB partition on a SSD drive. Bucket size=4M. The 
partition is aligned on a Gigabyte boundary.

- Backing device: 3.6 TiB partition on a HDD drive. There is 732 GiB of 
data usage on this partition. This 732 GiB are used by 9 qcow2 files 
assigned to 3 VMs running on the host.

- Neither the SDD nor HDD drives have another partitions in use.

- After 24 hours of use, according to priority_stats the cache is 75% 
Unused (63 GiB Unused - 19 GiB used), but...

- ... according to "smartctl -a" in those 24 hours "Writes to Flash" has 
increased in 160 GiB and "GB written from host" has increased in 90 GiB

- cache_hit_ratio is 10 %



- I'm using maximum bucket size (4M) trying to minimize write 
amplification. With this bucket size, "Writes to Flash" (160) to "GB 
written from host"(90) ratio is 1,78. Previously, some days ago, I was 
using default bucket size. The write amplification ratio then was 2,01.

- Isn't the cache_hit_ratio (10%) a bit low?

- Is it normal that, after 24 hours running, the cache occupation is 
that low (82-63 = 19GiB, 25%)  when the host has written 90 GiB to the 
cache device in the same period? I don´t understand why 90 GiB of data 
has been written to fill 19 GiB of cache.


Any ideas?


Thank you and regards.


-- 
___________________________________________________________

