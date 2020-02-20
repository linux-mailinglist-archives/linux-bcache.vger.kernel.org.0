Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD6A165E9E
	for <lists+linux-bcache@lfdr.de>; Thu, 20 Feb 2020 14:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgBTNVl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 20 Feb 2020 08:21:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:41884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbgBTNVl (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 20 Feb 2020 08:21:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92EF1ACA1;
        Thu, 20 Feb 2020 13:21:39 +0000 (UTC)
Subject: Re: [PATCH 1/3] bcache: move macro btree() and btree_root() into
 btree.h
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200215082858.128025-1-colyli@suse.de>
 <20200215082858.128025-2-colyli@suse.de>
 <20200219162945.GD10644@infradead.org>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <356c8b1c-d748-ce8d-ba4b-e498ce46fe03@suse.de>
Date:   Thu, 20 Feb 2020 21:21:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200219162945.GD10644@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/2/20 12:29 上午, Christoph Hellwig wrote:
> On Sat, Feb 15, 2020 at 04:28:56PM +0800, Coly Li wrote:
>> In order to accelerate bcache registration speed, the macro btree()
>> and btree_root() will be referenced out of btree.c. This patch moves
>> them from btree.c into btree.h with other relative function declaration
>> in btree.h, for the following changes.
> 
> Can you give them a bcache_ prefix?  That names are awfully generic
> and bound to clash sooner or later.
> 

Sure I will do it in next version.

Thanks.

-- 

Coly Li
