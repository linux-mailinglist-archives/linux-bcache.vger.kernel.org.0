Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69952204CC
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 08:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgGOGLh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 02:11:37 -0400
Received: from [195.135.220.15] ([195.135.220.15]:44774 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgGOGLh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 02:11:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1767AAB7A;
        Wed, 15 Jul 2020 06:11:39 +0000 (UTC)
Subject: Re: [PATCH v2 06/17] bcache: increase super block version for cache
 device and backing device
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715054612.6349-1-colyli@suse.de>
 <20200715054612.6349-7-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0cd5aa1d-528f-c949-5111-efa934aed073@suse.de>
Date:   Wed, 15 Jul 2020 08:11:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715054612.6349-7-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/15/20 7:46 AM, Coly Li wrote:
> The new added super block version BCACHE_SB_VERSION_BDEV_WITH_FEATURES
> (5) BCACHE_SB_VERSION_CDEV_WITH_FEATURES value (6), is for the feature
> set bits.
> 
> Devices have super block version equal to the new version will have
> three new members for feature set bits in the on-disk super block,
> /*078*/        __le64                  feature_compat;
> /*080*/        __le64                  feature_incompat;
> /*088*/        __le64                  feature_ro_compat;
> 
> They are used for further new features which may introduce on-disk
> format change, and avoid unncessary super block version increase.
> 
> The very basic features handling code skeleton is also initialized in
> this patch.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/features.h | 78 ++++++++++++++++++++++++++++++++++++
>   drivers/md/bcache/super.c    | 32 +++++++++++++--
>   include/uapi/linux/bcache.h  | 29 ++++++++++----
>   3 files changed, 128 insertions(+), 11 deletions(-)
>   create mode 100644 drivers/md/bcache/features.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
