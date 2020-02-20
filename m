Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3F7165EA1
	for <lists+linux-bcache@lfdr.de>; Thu, 20 Feb 2020 14:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgBTNV6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 20 Feb 2020 08:21:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:42016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728190AbgBTNV6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 20 Feb 2020 08:21:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 44950ACA1;
        Thu, 20 Feb 2020 13:21:57 +0000 (UTC)
Subject: Re: [PATCH 2/3] bcache: make bch_btree_check() to be multiple threads
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200215082858.128025-1-colyli@suse.de>
 <20200215082858.128025-3-colyli@suse.de>
 <20200219163015.GE10644@infradead.org>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <6f0d6571-bd01-528b-649c-1365ad2a4910@suse.de>
Date:   Thu, 20 Feb 2020 21:21:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200219163015.GE10644@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/2/20 12:30 上午, Christoph Hellwig wrote:
> maybe s/be multiple threads/multithreaded/ in the subject?
> 

Sure, I will do it in next version.

Thanks.

-- 

Coly Li
