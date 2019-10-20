Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D59DDD03
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2019 08:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfJTGYZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 20 Oct 2019 02:24:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:32916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726179AbfJTGYZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 20 Oct 2019 02:24:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E3BA8AB7F;
        Sun, 20 Oct 2019 06:24:23 +0000 (UTC)
Subject: Re: bcache kbuild cleanups
To:     Christoph Hellwig <hch@lst.de>
References: <20191015160409.14250-1-hch@lst.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <3035e39d-9fa8-a762-baf0-22bc90d2a6ad@suse.de>
Date:   Sun, 20 Oct 2019 14:24:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015160409.14250-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/10/16 12:04 上午, Christoph Hellwig wrote:
> Hi Coly,
> 
> this series removes a pointless cflags override and unused exports
> from bcache.
> 

Sure, I add them in my for-next series. Thansk.

-- 

Coly Li
