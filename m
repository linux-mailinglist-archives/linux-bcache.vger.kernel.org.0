Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B67C1D578F
	for <lists+linux-bcache@lfdr.de>; Fri, 15 May 2020 19:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgEORWo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 May 2020 13:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgEORWo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 May 2020 13:22:44 -0400
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D95120727;
        Fri, 15 May 2020 17:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589563363;
        bh=7WPQmTCPAvdVxUliB6KAZ3vpEVe0ZxmX97cunM2QPiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kksoEX4n3gLOOzWunMvg8pxo8+42AgRdI/+k2Lf6tdsfJyRxz1BISiyBfFXJe0dy/
         b4CaBYBjnLpEp0Z0dxgMbd+MtGWWKJES0Fyt46PqYK1oGFzhFrosjQ6+0QG0JAUyhv
         zXpekmvDSVv9hmi+RjESnyfvQVokUZP4AjWN+RPU=
Date:   Sat, 16 May 2020 02:22:35 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com,
        hch@lst.de, axboe@kernel.dk, linux-bcache@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [RFC PATCH 2/4] block: block: change REQ_OP_ZONE_RESET from 8 to
 15
Message-ID: <20200515172235.GA21682@redsun51.ssa.fujisawa.hgst.com>
References: <20200515163157.72796-1-colyli@suse.de>
 <20200515163157.72796-3-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515163157.72796-3-colyli@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The subject title for this patch should mention "REQ_OP_ZONE_RESET_ALL"
instead of "REQ_OP_ZONE_RESET".
