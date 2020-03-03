Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6A1176A0C
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Mar 2020 02:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCCBa1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 20:30:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:41022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgCCBa1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 20:30:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 91AF4AC92;
        Tue,  3 Mar 2020 01:30:25 +0000 (UTC)
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc:     Michal Hocko <mhocko@kernel.org>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com, Oleg Nesterov <oleg@redhat.com>,
        Christoph Hellwig <hch@lst.de>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
 <20200302134048.GK4380@dhcp22.suse.cz>
 <cc759569-e79e-a1a0-3019-0e07dd6957cb@suse.de>
 <20200302172840.GQ4380@dhcp22.suse.cz>
 <5693a819-e323-3232-2048-413566c2254f@suse.de>
 <495d18c6-3776-33c7-c48b-bb85b31c3a96@cloud.ionos.com>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <fc05381c-f14f-3a40-465d-a8510fe6e93b@suse.de>
Date:   Tue, 3 Mar 2020 09:30:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <495d18c6-3776-33c7-c48b-bb85b31c3a96@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/3/3 9:22 上午, Guoqing Jiang wrote:
> Hi Coly,
> 
> On 3/2/20 6:47 PM, Coly Li wrote:
>>> I have a vague recollection that there are mutlitple timeouts and
>>> setting only some is not sufficient.
>>>
>> Let me try out how to extend udevd timeout.
> 
> Not sure if this link [1] helps or not, just FYI.
> 
> [1] https://github.com/jonathanunderwood/mdraid-safe-timeouts
> 

Guoqing,

Thanks. Let me look into it :-)

-- 

Coly Li
